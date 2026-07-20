import Foundation

enum AppPaths {
    static let applicationSupportURL = FileManager.default.homeDirectoryForCurrentUser
        .appending(path: "Library/Application Support/GeoShift")

    static let configurationURL = applicationSupportURL.appending(path: "config.json")

    static let statusURL = applicationSupportURL.appending(path: "status.json")

    static let pairingStatusURL = applicationSupportURL.appending(path: "pairing-status.json")

    static let pairingRecordsURL = FileManager.default.homeDirectoryForCurrentUser
        .appending(path: ".pymobiledevice3")

    static let logURL = FileManager.default.homeDirectoryForCurrentUser
        .appending(path: "Library/Logs/GeoShift.log")

    static let legacyConfigurationURL = FileManager.default.homeDirectoryForCurrentUser
        .appending(path: "Library/Application Support/Belgrade Location/config.json")
}
