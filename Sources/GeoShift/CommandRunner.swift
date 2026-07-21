@preconcurrency import Foundation

private final class CommandExecution: @unchecked Sendable {
    private let stateLock = NSLock()
    private let process = Process()
    private let outputURL: URL
    private let outputHandle: FileHandle
    private var continuation: CheckedContinuation<CommandResult, Never>?
    private var timeoutTask: Task<Void, Never>?
    private var didFinish = false
    private var didCleanUp = false

    init?() {
        outputURL = FileManager.default.temporaryDirectory
            .appending(path: "GeoShift-command-\(UUID().uuidString).log")
        guard FileManager.default.createFile(
            atPath: outputURL.path(),
            contents: nil,
            attributes: [.posixPermissions: 0o600]
        ), let handle = try? FileHandle(forWritingTo: outputURL) else {
            return nil
        }
        outputHandle = handle
        process.standardOutput = handle
        process.standardError = handle
    }

    func run(
        executable: String,
        arguments: [String],
        timeoutSeconds: Double
    ) async -> CommandResult {
        process.executableURL = URL(fileURLWithPath: executable)
        process.arguments = arguments

        return await withCheckedContinuation { continuation in
            stateLock.lock()
            self.continuation = continuation
            stateLock.unlock()

            process.terminationHandler = { [weak self] process in
                self?.processDidTerminate(status: process.terminationStatus)
            }

            do {
                try process.run()
            } catch {
                finish(
                    CommandResult(status: -1, output: error.localizedDescription),
                    processHasTerminated: true
                )
                cleanUpOutput()
                return
            }

            let task = Task { [weak self] in
                do {
                    try await Task.sleep(for: .seconds(timeoutSeconds))
                } catch {
                    return
                }
                self?.timeOut(after: timeoutSeconds)
            }

            stateLock.lock()
            if didFinish {
                task.cancel()
            } else {
                timeoutTask = task
            }
            stateLock.unlock()
        }
    }

    private func processDidTerminate(status: Int32) {
        let output = readOutputAndCleanUp()
        finish(
            CommandResult(status: status, output: output),
            processHasTerminated: true
        )
    }

    private func timeOut(after seconds: Double) {
        let result = CommandResult(
            status: -2,
            output: "The command timed out after \(Int(seconds)) seconds."
        )
        guard finish(result, processHasTerminated: false) else {
            return
        }

        process.terminate()
        if process.isRunning {
            kill(process.processIdentifier, SIGKILL)
        }
        cleanUpOutput()
    }

    @discardableResult
    private func finish(
        _ result: CommandResult,
        processHasTerminated: Bool
    ) -> Bool {
        let continuation: CheckedContinuation<CommandResult, Never>?
        let timeoutTask: Task<Void, Never>?

        stateLock.lock()
        if didFinish {
            stateLock.unlock()
            if processHasTerminated {
                cleanUpOutput()
            }
            return false
        }
        didFinish = true
        continuation = self.continuation
        self.continuation = nil
        timeoutTask = self.timeoutTask
        self.timeoutTask = nil
        stateLock.unlock()

        timeoutTask?.cancel()
        continuation?.resume(returning: result)
        return true
    }

    private func readOutputAndCleanUp() -> String {
        stateLock.lock()
        if didCleanUp {
            stateLock.unlock()
            return ""
        }
        didCleanUp = true
        stateLock.unlock()

        try? outputHandle.synchronize()
        try? outputHandle.close()
        let data = (try? Data(contentsOf: outputURL)) ?? Data()
        try? FileManager.default.removeItem(at: outputURL)
        return String(decoding: data, as: UTF8.self)
    }

    private func cleanUpOutput() {
        _ = readOutputAndCleanUp()
    }
}

actor CommandRunner {
    func run(
        _ executable: String,
        arguments: [String],
        timeoutSeconds: Double = 5
    ) async -> CommandResult {
        guard let execution = CommandExecution() else {
            return CommandResult(
                status: -1,
                output: "Could not create a temporary command output file."
            )
        }
        return await execution.run(
            executable: executable,
            arguments: arguments,
            timeoutSeconds: timeoutSeconds
        )
    }
}
