import Foundation

struct WorkerStatus: Codable, Equatable, Sendable {
    enum Phase: String, Codable, Sendable {
        case starting
        case connecting
        case waitingForDevice
        case applying
        case active
        case clearing
        case clearPending
        case cleared
        case failed
    }

    let phase: Phase
    let requestID: String
    let deviceUDID: String?
    let simulationMayBeActive: Bool
    let message: String?
    let updatedAt: Double
}
