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

    var title: String {
        switch self {
        case .balkans:
            "Балканы"
        case .europe:
            "Европа"
        case .middleEastAfrica:
            "Ближний Восток и Африка"
        case .asia:
            "Азия"
        case .northAmerica:
            "Северная Америка"
        case .latinAmerica:
            "Латинская Америка"
        case .oceania:
            "Австралия и Океания"
        }
    }
}
