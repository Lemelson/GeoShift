import Foundation
import Testing
@testable import GeoShift

@Suite("City catalog")
struct CityCatalogTests {
    @Test("Catalog contains a broad set of unique destinations")
    func uniqueDestinations() {
        let identifiers = CityCatalog.cities.map(\.id)

        #expect(CityCatalog.cities.count >= 90)
        #expect(Set(identifiers).count == identifiers.count)
    }

    @Test("Requested destinations are available")
    func requiredCities() {
        let required = [
            "belgrade", "moscow", "warsaw", "budapest", "bucharest",
            "istanbul", "rome", "milan", "berlin", "copenhagen",
            "stockholm", "helsinki", "oslo", "paris", "madrid",
            "barcelona", "london", "dubai", "bangkok", "phuket",
            "sydney", "new-york", "mexico-city", "buenos-aires",
        ]

        for identifier in required {
            #expect(CityCatalog.city(withID: identifier) != nil)
        }
    }

    @Test("Search matches city, country, and region")
    func search() {
        let thailand = CityCatalog.sections(matching: "Таиланд")
            .flatMap(\.cities)
            .map(\.id)
        let balkans = CityCatalog.sections(matching: "Балканы")
            .flatMap(\.cities)
            .map(\.id)
        let thailandEnglish = CityCatalog.sections(matching: "Thailand")
            .flatMap(\.cities)
            .map(\.id)
        let balkansEnglish = CityCatalog.sections(matching: "Balkans")
            .flatMap(\.cities)
            .map(\.id)

        #expect(thailand.contains("bangkok"))
        #expect(thailand.contains("phuket"))
        #expect(balkans.contains("belgrade"))
        #expect(!balkans.contains("paris"))
        #expect(thailandEnglish.contains("bangkok"))
        #expect(balkansEnglish.contains("belgrade"))
    }

    @Test("Every city has English and Russian display values")
    func bilingualDisplayValues() {
        for city in CityCatalog.cities {
            #expect(!city.localizedName(for: .english).isEmpty)
            #expect(!city.localizedName(for: .russian).isEmpty)
            #expect(!city.localizedCountry(for: .english).isEmpty)
            #expect(!city.localizedCountry(for: .russian).isEmpty)
            #expect(city.localizedName(for: .english).range(of: "[А-Яа-яЁё]", options: .regularExpression) == nil)
            #expect(city.localizedCountry(for: .english).range(of: "[А-Яа-яЁё]", options: .regularExpression) == nil)
        }

        #expect(CityCatalog.city(withID: "bogota")?.localizedName(for: .english) == "Bogotá")
        #expect(CityCatalog.city(withID: "ho-chi-minh")?.localizedName(for: .english) == "Ho Chi Minh City")
        #expect(CityCatalog.city(withID: "san-jose")?.localizedName(for: .english) == "San José")
    }
}
