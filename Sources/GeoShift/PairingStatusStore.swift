import Foundation

enum PairingStatusStore {
    static func load() -> PairingStatus? {
        guard let data = try? Data(contentsOf: AppPaths.pairingStatusURL) else {
            return nil
        }
        return try? JSONDecoder().decode(PairingStatus.self, from: data)
    }

    static var hasWirelessPairing: Bool {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: AppPaths.pairingRecordsURL,
            includingPropertiesForKeys: nil
        ) else {
            return false
        }
        return files.contains { $0.lastPathComponent.hasPrefix("remote_") && $0.pathExtension == "plist" }
    }
}
