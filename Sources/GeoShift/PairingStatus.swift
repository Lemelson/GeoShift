import Foundation

struct PairingStatus: Codable, Equatable, Sendable {
    enum Phase: String, Codable, Sendable {
        case advertising
        case codeReady
        case paired
        case failed
    }

    let phase: Phase
    let code: String?
    let deviceUDID: String?
    let message: String
    let updatedAt: Double
}
