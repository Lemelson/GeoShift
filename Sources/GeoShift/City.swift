import Foundation

struct City: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let name: String
    let country: String
    let flag: String
    let region: CityRegion
    let latitude: Double
    let longitude: Double

    func localizedName(for language: AppLanguage) -> String {
        switch language {
        case .english:
            Self.englishNameOverrides[id] ?? id
                .replacing("-", with: " ")
                .capitalized(with: Locale(identifier: "en_US"))
        case .russian:
            name
        }
    }

    func localizedCountry(for language: AppLanguage) -> String {
        switch language {
        case .english:
            guard let countryCode else {
                return country
            }
            return Locale(identifier: "en_US").localizedString(forRegionCode: countryCode) ?? country
        case .russian:
            return country
        }
    }

    func matches(_ query: String) -> Bool {
        query.isEmpty ||
            name.localizedStandardContains(query) ||
            country.localizedStandardContains(query) ||
            localizedName(for: .english).localizedStandardContains(query) ||
            localizedCountry(for: .english).localizedStandardContains(query) ||
            region.searchTerms.localizedStandardContains(query)
    }

    private var countryCode: String? {
        let letters = flag.unicodeScalars.compactMap { scalar -> Character? in
            guard (127_462...127_487).contains(scalar.value),
                  let letter = UnicodeScalar(scalar.value - 127_397) else {
                return nil
            }
            return Character(String(letter))
        }
        return letters.count == 2 ? String(letters) : nil
    }

    private static let englishNameOverrides = [
        "bali": "Bali · Denpasar",
        "bogota": "Bogotá",
        "cancun": "Cancún",
        "ho-chi-minh": "Ho Chi Minh City",
        "krakow": "Kraków",
        "medellin": "Medellín",
        "rio": "Rio de Janeiro",
        "san-jose": "San José",
        "sao-paulo": "São Paulo",
    ]
}
