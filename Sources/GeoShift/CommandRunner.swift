@preconcurrency import Foundation

actor CommandRunner {
    func run(_ executable: String, arguments: [String]) async -> CommandResult {
        await withCheckedContinuation { continuation in
            let process = Process()
            let outputPipe = Pipe()

            process.executableURL = URL(fileURLWithPath: executable)
            process.arguments = arguments
            process.standardOutput = outputPipe
            process.standardError = outputPipe

            process.terminationHandler = { finishedProcess in
                let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(decoding: data, as: UTF8.self)
                continuation.resume(
                    returning: CommandResult(
                        status: finishedProcess.terminationStatus,
                        output: output
                    )
                )
            }

            do {
                try process.run()
            } catch {
                continuation.resume(
                    returning: CommandResult(
                        status: -1,
                        output: error.localizedDescription
                    )
                )
            }
        }
    }
}
