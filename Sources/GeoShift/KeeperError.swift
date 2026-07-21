import Foundation

enum KeeperError: LocalizedError {
    case commandFailed(String)
    case missingDependency(String)
    case missingKeeper
    case missingLivenessLease

    var errorDescription: String? {
        switch self {
        case .commandFailed(let output):
            output.isEmpty ? "The command failed." : output
        case .missingDependency(let path):
            "pymobiledevice3 was not found: \(path)"
        case .missingKeeper:
            "keeper.py is missing from the app bundle."
        case .missingLivenessLease:
            "GeoShift could not acquire its process-liveness lock."
        }
    }

    @MainActor
    func description(using localization: LocalizationStore) -> String {
        switch self {
        case .commandFailed:
            // Process and launchctl output is diagnostic data, not UI copy.
            // Keep the error banner localized instead of exposing arbitrary
            // English system messages when the app is set to Russian.
            localization.text("error.commandFailed")
        case .missingDependency(let path):
            "\(localization.text("error.missingDependency")): \(path)"
        case .missingKeeper:
            localization.text("error.missingKeeper")
        case .missingLivenessLease:
            localization.text("error.missingLivenessLease")
        }
    }
}
