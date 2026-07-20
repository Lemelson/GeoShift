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

    var locale: Locale {
        Locale(identifier: rawValue)
    }
}
