struct CitySection: Identifiable, Sendable {
    let region: CityRegion
    let cities: [City]

    var id: CityRegion {
        region
    }
}
