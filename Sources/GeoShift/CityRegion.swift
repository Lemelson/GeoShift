enum CityRegion: String, CaseIterable, Identifiable, Codable, Sendable {
    case balkans
    case europe
    case middleEastAfrica
    case asia
    case northAmerica
    case latinAmerica
    case oceania

    var id: String {
        rawValue
    }

    @MainActor
    func title(using localization: LocalizationStore) -> String {
        switch self {
        case .balkans:
            localization.text("region.balkans")
        case .europe:
            localization.text("region.europe")
        case .middleEastAfrica:
            localization.text("region.middleEastAfrica")
        case .asia:
            localization.text("region.asia")
        case .northAmerica:
            localization.text("region.northAmerica")
        case .latinAmerica:
            localization.text("region.latinAmerica")
        case .oceania:
            localization.text("region.oceania")
        }
    }

    var searchTerms: String {
        switch self {
        case .balkans:
            "Balkans Балканы"
        case .europe:
            "Europe Европа"
        case .middleEastAfrica:
            "Middle East Africa Ближний Восток Африка"
        case .asia:
            "Asia Азия"
        case .northAmerica:
            "North America Северная Америка"
        case .latinAmerica:
            "Latin America Латинская Америка"
        case .oceania:
            "Australia Oceania Австралия Океания"
        }
    }
}
