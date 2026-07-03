import SwiftUI

enum KeeperState: Sendable {
    case stopped
    case waiting
    case active
    case working
    case failed

    var title: String {
        switch self {
        case .stopped:
            "Остановлено"
        case .waiting:
            "Ожидание iPhone"
        case .active:
            "Белград активен"
        case .working:
            "Подключение…"
        case .failed:
            "Требуется внимание"
        }
    }

    var systemImage: String {
        switch self {
        case .stopped:
            "stop.circle"
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
            .secondary
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
