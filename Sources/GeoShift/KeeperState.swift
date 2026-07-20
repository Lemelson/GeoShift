import SwiftUI

enum KeeperState: Sendable {
    case stopped
    case restoring
    case waiting
    case active
    case working
    case failed

    @MainActor
    func title(using localization: LocalizationStore) -> String {
        switch self {
        case .stopped:
            localization.text("state.stopped")
        case .restoring:
            localization.text("state.restoring")
        case .waiting:
            localization.text("state.waiting")
        case .active:
            localization.text("state.active")
        case .working:
            localization.text("state.working")
        case .failed:
            localization.text("state.failed")
        }
    }

    var systemImage: String {
        switch self {
        case .stopped:
            "location.slash.circle"
        case .restoring:
            "iphone.gen3.radiowaves.left.and.right"
        case .waiting:
            "iphone.gen3.badge.exclamationmark"
        case .active:
            "location.fill"
        case .working:
            "arrow.trianglehead.2.clockwise"
        case .failed:
            "exclamationmark.triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .stopped:
            .green
        case .restoring:
            .orange
        case .waiting:
            .orange
        case .active:
            .green
        case .working:
            .blue
        case .failed:
            .red
        }
    }
}
