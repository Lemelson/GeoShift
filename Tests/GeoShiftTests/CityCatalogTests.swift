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

        #expect(thailand.contains("bangkok"))
        #expect(thailand.contains("phuket"))
        #expect(balkans.contains("belgrade"))
        #expect(!balkans.contains("paris"))
    }
}
