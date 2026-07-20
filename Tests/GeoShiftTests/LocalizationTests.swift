import Foundation
import Testing
@testable import GeoShift

@Suite("App localization")
@MainActor
struct LocalizationTests {
    @Test("English is the default and an invalid saved value fails back to English")
    func englishDefault() throws {
        let (defaults, suiteName) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: suiteName) }

        #expect(LocalizationStore(defaults: defaults).language == .english)

        defaults.set("unsupported", forKey: "appLanguage")
        #expect(LocalizationStore(defaults: defaults).language == .english)
    }

    @Test("Russian selection persists across store recreation")
    func russianPersistence() throws {
        let (defaults, suiteName) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let first = LocalizationStore(defaults: defaults)
        first.language = .russian

        let restored = LocalizationStore(defaults: defaults)
        #expect(restored.language == .russian)
        #expect(restored.text("control.restore") == "Вернуть GPS")
    }

    @Test("Both languages provide translated user-facing strings")
    func translatedResources() throws {
        let (defaults, suiteName) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let localization = LocalizationStore(defaults: defaults)

        localization.language = .english
        #expect(localization.text("header.subtitle") == "Control iPhone GPS simulation from your Mac")
        #expect(localization.text("settings.language") == "App language")

        localization.language = .russian
        #expect(localization.text("header.subtitle").contains("симуляцией GPS"))
        #expect(localization.text("settings.language") == "Язык приложения")
        #expect(KeeperError.commandFailed("The command timed out after 5 seconds.")
            .description(using: localization) == "Команда завершилась с ошибкой.")
    }

    private func makeDefaults() throws -> (UserDefaults, String) {
        let suiteName = "GeoShift.LocalizationTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suiteName))
        defaults.removePersistentDomain(forName: suiteName)
        return (defaults, suiteName)
    }
}
