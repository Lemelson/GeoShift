import Foundation

enum LaunchAgentConfiguration {
    static func programArguments(pythonPath: String, keeperURL: URL) -> [String] {
        [
            "/usr/bin/caffeinate",
            "-i",
            pythonPath,
            keeperURL.path(percentEncoded: false),
        ]
    }
}
