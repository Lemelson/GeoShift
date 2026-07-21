import Foundation

enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case english = "en"
    case russian = "ru"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english:
            "English"
        case .russian:
            "Русский"
        }
    }

    var selectionLabel: String {
        switch self {
        case .english:
            "🇬🇧 \(displayName)"
        case .russian:
            "🇷🇺 \(displayName)"
        }
    }

    var locale: Locale {
        Locale(identifier: rawValue)
    }
}
