@preconcurrency import Foundation

private final class CommandExecution: @unchecked Sendable {
    let process = Process()
    let outputPipe = Pipe()

    func waitForResult() -> CommandResult {
        process.waitUntilExit()
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        return CommandResult(
            status: process.terminationStatus,
            output: String(decoding: data, as: UTF8.self)
        )
    }

    func terminate() {
        guard process.isRunning else {
            return
        }
        process.terminate()
    }

    func killIfNeeded() {
        if process.isRunning {
            kill(process.processIdentifier, SIGKILL)
        }
    }
}

actor CommandRunner {
    func run(
        _ executable: String,
        arguments: [String],
        timeoutSeconds: Double = 5
    ) async -> CommandResult {
        let execution = CommandExecution()
        execution.process.executableURL = URL(fileURLWithPath: executable)
        execution.process.arguments = arguments
        execution.process.standardOutput = execution.outputPipe
        execution.process.standardError = execution.outputPipe

        do {
            try execution.process.run()
        } catch {
            return CommandResult(status: -1, output: error.localizedDescription)
        }

        return await withTaskGroup(of: CommandResult.self) { group in
            group.addTask {
                execution.waitForResult()
            }
            group.addTask {
                do {
                    try await Task.sleep(for: .seconds(timeoutSeconds))
                } catch {
                    return CommandResult(status: -2, output: "The command was cancelled.")
                }

                execution.terminate()
                try? await Task.sleep(for: .seconds(2))
                execution.killIfNeeded()
                return CommandResult(
                    status: -2,
                    output: "The command timed out after \(Int(timeoutSeconds)) seconds."
                )
            }

            let result = await group.next() ?? CommandResult(
                status: -2,
                output: "The command returned no result."
            )
            group.cancelAll()
            return result
        }
    }
}
