import Foundation
import Observation

@MainActor
@Observable
final class LocalizationStore {
    private static let defaultsKey = "appLanguage"
    private let defaults: UserDefaults

    var language: AppLanguage {
        didSet {
            defaults.set(language.rawValue, forKey: Self.defaultsKey)
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let saved = defaults.string(forKey: Self.defaultsKey),
           let language = AppLanguage(rawValue: saved) {
            self.language = language
        } else {
            language = .english
        }
    }

    func text(_ key: String) -> String {
        #if DEBUG
        let resources = Bundle.main.path(forResource: "en", ofType: "lproj") == nil
            ? Bundle.module
            : Bundle.main
        #else
        let resources = Bundle.main
        #endif
        guard let path = resources.path(forResource: language.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return key
        }
        return bundle.localizedString(forKey: key, value: key, table: nil)
    }
}
