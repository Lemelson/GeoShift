import Foundation

enum AppPaths {
    static let applicationSupportURL = FileManager.default.homeDirectoryForCurrentUser
        .appending(path: "Library/Application Support/GeoShift")

    static let configurationURL = applicationSupportURL.appending(path: "config.json")

    static let logURL = FileManager.default.homeDirectoryForCurrentUser
        .appending(path: "Library/Logs/GeoShift.log")

    static let legacyConfigurationURL = FileManager.default.homeDirectoryForCurrentUser
        .appending(path: "Library/Application Support/Belgrade Location/config.json")
}
