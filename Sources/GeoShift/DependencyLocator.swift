import Foundation

enum DependencyLocator {
    static func pymobiledevicePython() -> String? {
        let home = FileManager.default.homeDirectoryForCurrentUser.path()
        let candidates = [
            "\(home)/.local/share/uv/tools/pymobiledevice3/bin/python",
            "\(home)/.local/pipx/venvs/pymobiledevice3/bin/python",
            "\(home)/.local/share/pipx/venvs/pymobiledevice3/bin/python",
        ]

        if let candidate = candidates.first(where: FileManager.default.isExecutableFile) {
            return candidate
        }

        let commandCandidates = [
            "\(home)/.local/bin/pymobiledevice3",
            "/opt/homebrew/bin/pymobiledevice3",
            "/usr/local/bin/pymobiledevice3",
        ]

        for command in commandCandidates where FileManager.default.isExecutableFile(atPath: command) {
            guard
                let firstLine = try? String(contentsOfFile: command, encoding: .utf8)
                    .split(separator: "\n", maxSplits: 1)
                    .first,
                firstLine.hasPrefix("#!")
            else {
                continue
            }

            let interpreter = String(firstLine.dropFirst(2))
            if FileManager.default.isExecutableFile(atPath: interpreter) {
                return interpreter
            }
        }

        return nil
    }
}
