struct City: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let name: String
    let country: String
    let flag: String
    let region: CityRegion
    let latitude: Double
    let longitude: Double

    var displayName: String {
        "\(flag) \(name)"
    }

    var subtitle: String {
        "\(country) · \(region.title)"
    }

    func matches(_ query: String) -> Bool {
        query.isEmpty ||
            name.localizedStandardContains(query) ||
            country.localizedStandardContains(query) ||
            region.title.localizedStandardContains(query)
    }
}
