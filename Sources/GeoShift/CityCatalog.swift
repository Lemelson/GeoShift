enum CityCatalog {
    static let defaultCityID = "belgrade"

    static let cities: [City] = [
        // Balkans
        City(id: "belgrade", name: "Белград", country: "Сербия", flag: "🇷🇸", region: .balkans, latitude: 44.8125, longitude: 20.4612),
        City(id: "novi-sad", name: "Нови-Сад", country: "Сербия", flag: "🇷🇸", region: .balkans, latitude: 45.2671, longitude: 19.8335),
        City(id: "sarajevo", name: "Сараево", country: "Босния и Герцеговина", flag: "🇧🇦", region: .balkans, latitude: 43.8563, longitude: 18.4131),
        City(id: "zagreb", name: "Загреб", country: "Хорватия", flag: "🇭🇷", region: .balkans, latitude: 45.8150, longitude: 15.9819),
        City(id: "split", name: "Сплит", country: "Хорватия", flag: "🇭🇷", region: .balkans, latitude: 43.5081, longitude: 16.4402),
        City(id: "dubrovnik", name: "Дубровник", country: "Хорватия", flag: "🇭🇷", region: .balkans, latitude: 42.6507, longitude: 18.0944),
        City(id: "ljubljana", name: "Любляна", country: "Словения", flag: "🇸🇮", region: .balkans, latitude: 46.0569, longitude: 14.5058),
        City(id: "podgorica", name: "Подгорица", country: "Черногория", flag: "🇲🇪", region: .balkans, latitude: 42.4304, longitude: 19.2594),
        City(id: "budva", name: "Будва", country: "Черногория", flag: "🇲🇪", region: .balkans, latitude: 42.2911, longitude: 18.8403),
        City(id: "tirana", name: "Тирана", country: "Албания", flag: "🇦🇱", region: .balkans, latitude: 41.3275, longitude: 19.8187),
        City(id: "pristina", name: "Приштина", country: "Косово", flag: "🇽🇰", region: .balkans, latitude: 42.6629, longitude: 21.1655),
        City(id: "skopje", name: "Скопье", country: "Северная Македония", flag: "🇲🇰", region: .balkans, latitude: 41.9981, longitude: 21.4254),
        City(id: "sofia", name: "София", country: "Болгария", flag: "🇧🇬", region: .balkans, latitude: 42.6977, longitude: 23.3219),
        City(id: "thessaloniki", name: "Салоники", country: "Греция", flag: "🇬🇷", region: .balkans, latitude: 40.6401, longitude: 22.9444),
        City(id: "athens", name: "Афины", country: "Греция", flag: "🇬🇷", region: .balkans, latitude: 37.9838, longitude: 23.7275),

        // Europe
        City(id: "moscow", name: "Москва", country: "Россия", flag: "🇷🇺", region: .europe, latitude: 55.7558, longitude: 37.6173),
        City(id: "warsaw", name: "Варшава", country: "Польша", flag: "🇵🇱", region: .europe, latitude: 52.2297, longitude: 21.0122),
        City(id: "krakow", name: "Краков", country: "Польша", flag: "🇵🇱", region: .europe, latitude: 50.0647, longitude: 19.9450),
        City(id: "prague", name: "Прага", country: "Чехия", flag: "🇨🇿", region: .europe, latitude: 50.0755, longitude: 14.4378),
        City(id: "budapest", name: "Будапешт", country: "Венгрия", flag: "🇭🇺", region: .europe, latitude: 47.4979, longitude: 19.0402),
        City(id: "bucharest", name: "Бухарест", country: "Румыния", flag: "🇷🇴", region: .europe, latitude: 44.4268, longitude: 26.1025),
        City(id: "vienna", name: "Вена", country: "Австрия", flag: "🇦🇹", region: .europe, latitude: 48.2082, longitude: 16.3738),
        City(id: "berlin", name: "Берлин", country: "Германия", flag: "🇩🇪", region: .europe, latitude: 52.5200, longitude: 13.4050),
        City(id: "munich", name: "Мюнхен", country: "Германия", flag: "🇩🇪", region: .europe, latitude: 48.1351, longitude: 11.5820),
        City(id: "hamburg", name: "Гамбург", country: "Германия", flag: "🇩🇪", region: .europe, latitude: 53.5511, longitude: 9.9937),
        City(id: "copenhagen", name: "Копенгаген", country: "Дания", flag: "🇩🇰", region: .europe, latitude: 55.6761, longitude: 12.5683),
        City(id: "stockholm", name: "Стокгольм", country: "Швеция", flag: "🇸🇪", region: .europe, latitude: 59.3293, longitude: 18.0686),
        City(id: "helsinki", name: "Хельсинки", country: "Финляндия", flag: "🇫🇮", region: .europe, latitude: 60.1699, longitude: 24.9384),
        City(id: "oslo", name: "Осло", country: "Норвегия", flag: "🇳🇴", region: .europe, latitude: 59.9139, longitude: 10.7522),
        City(id: "amsterdam", name: "Амстердам", country: "Нидерланды", flag: "🇳🇱", region: .europe, latitude: 52.3676, longitude: 4.9041),
        City(id: "brussels", name: "Брюссель", country: "Бельгия", flag: "🇧🇪", region: .europe, latitude: 50.8503, longitude: 4.3517),
        City(id: "paris", name: "Париж", country: "Франция", flag: "🇫🇷", region: .europe, latitude: 48.8566, longitude: 2.3522),
        City(id: "nice", name: "Ницца", country: "Франция", flag: "🇫🇷", region: .europe, latitude: 43.7102, longitude: 7.2620),
        City(id: "london", name: "Лондон", country: "Великобритания", flag: "🇬🇧", region: .europe, latitude: 51.5074, longitude: -0.1278),
        City(id: "dublin", name: "Дублин", country: "Ирландия", flag: "🇮🇪", region: .europe, latitude: 53.3498, longitude: -6.2603),
        City(id: "lisbon", name: "Лиссабон", country: "Португалия", flag: "🇵🇹", region: .europe, latitude: 38.7223, longitude: -9.1393),
        City(id: "porto", name: "Порту", country: "Португалия", flag: "🇵🇹", region: .europe, latitude: 41.1579, longitude: -8.6291),
        City(id: "madrid", name: "Мадрид", country: "Испания", flag: "🇪🇸", region: .europe, latitude: 40.4168, longitude: -3.7038),
        City(id: "barcelona", name: "Барселона", country: "Испания", flag: "🇪🇸", region: .europe, latitude: 41.3874, longitude: 2.1686),
        City(id: "valencia", name: "Валенсия", country: "Испания", flag: "🇪🇸", region: .europe, latitude: 39.4699, longitude: -0.3763),
        City(id: "rome", name: "Рим", country: "Италия", flag: "🇮🇹", region: .europe, latitude: 41.9028, longitude: 12.4964),
        City(id: "milan", name: "Милан", country: "Италия", flag: "🇮🇹", region: .europe, latitude: 45.4642, longitude: 9.1900),
        City(id: "florence", name: "Флоренция", country: "Италия", flag: "🇮🇹", region: .europe, latitude: 43.7696, longitude: 11.2558),
        City(id: "istanbul", name: "Стамбул", country: "Турция", flag: "🇹🇷", region: .europe, latitude: 41.0082, longitude: 28.9784),
        City(id: "antalya", name: "Анталья", country: "Турция", flag: "🇹🇷", region: .europe, latitude: 36.8969, longitude: 30.7133),
        City(id: "tbilisi", name: "Тбилиси", country: "Грузия", flag: "🇬🇪", region: .europe, latitude: 41.7151, longitude: 44.8271),
        City(id: "batumi", name: "Батуми", country: "Грузия", flag: "🇬🇪", region: .europe, latitude: 41.6168, longitude: 41.6367),
        City(id: "yerevan", name: "Ереван", country: "Армения", flag: "🇦🇲", region: .europe, latitude: 40.1872, longitude: 44.5152),

        // Middle East and Africa
        City(id: "dubai", name: "Дубай", country: "ОАЭ", flag: "🇦🇪", region: .middleEastAfrica, latitude: 25.2048, longitude: 55.2708),
        City(id: "abu-dhabi", name: "Абу-Даби", country: "ОАЭ", flag: "🇦🇪", region: .middleEastAfrica, latitude: 24.4539, longitude: 54.3773),
        City(id: "doha", name: "Доха", country: "Катар", flag: "🇶🇦", region: .middleEastAfrica, latitude: 25.2854, longitude: 51.5310),
        City(id: "tel-aviv", name: "Тель-Авив", country: "Израиль", flag: "🇮🇱", region: .middleEastAfrica, latitude: 32.0853, longitude: 34.7818),
        City(id: "beirut", name: "Бейрут", country: "Ливан", flag: "🇱🇧", region: .middleEastAfrica, latitude: 33.8938, longitude: 35.5018),
        City(id: "cairo", name: "Каир", country: "Египет", flag: "🇪🇬", region: .middleEastAfrica, latitude: 30.0444, longitude: 31.2357),
        City(id: "marrakech", name: "Марракеш", country: "Марокко", flag: "🇲🇦", region: .middleEastAfrica, latitude: 31.6295, longitude: -7.9811),
        City(id: "casablanca", name: "Касабланка", country: "Марокко", flag: "🇲🇦", region: .middleEastAfrica, latitude: 33.5731, longitude: -7.5898),
        City(id: "cape-town", name: "Кейптаун", country: "ЮАР", flag: "🇿🇦", region: .middleEastAfrica, latitude: -33.9249, longitude: 18.4241),
        City(id: "johannesburg", name: "Йоханнесбург", country: "ЮАР", flag: "🇿🇦", region: .middleEastAfrica, latitude: -26.2041, longitude: 28.0473),
        City(id: "nairobi", name: "Найроби", country: "Кения", flag: "🇰🇪", region: .middleEastAfrica, latitude: -1.2921, longitude: 36.8219),
        City(id: "zanzibar", name: "Занзибар", country: "Танзания", flag: "🇹🇿", region: .middleEastAfrica, latitude: -6.1659, longitude: 39.2026),
        City(id: "lagos", name: "Лагос", country: "Нигерия", flag: "🇳🇬", region: .middleEastAfrica, latitude: 6.5244, longitude: 3.3792),

        // Asia
        City(id: "bangkok", name: "Бангкок", country: "Таиланд", flag: "🇹🇭", region: .asia, latitude: 13.7563, longitude: 100.5018),
        City(id: "phuket", name: "Пхукет", country: "Таиланд", flag: "🇹🇭", region: .asia, latitude: 7.8804, longitude: 98.3923),
        City(id: "chiang-mai", name: "Чиангмай", country: "Таиланд", flag: "🇹🇭", region: .asia, latitude: 18.7883, longitude: 98.9853),
        City(id: "singapore", name: "Сингапур", country: "Сингапур", flag: "🇸🇬", region: .asia, latitude: 1.3521, longitude: 103.8198),
        City(id: "kuala-lumpur", name: "Куала-Лумпур", country: "Малайзия", flag: "🇲🇾", region: .asia, latitude: 3.1390, longitude: 101.6869),
        City(id: "bali", name: "Бали · Денпасар", country: "Индонезия", flag: "🇮🇩", region: .asia, latitude: -8.6500, longitude: 115.2167),
        City(id: "tokyo", name: "Токио", country: "Япония", flag: "🇯🇵", region: .asia, latitude: 35.6762, longitude: 139.6503),
        City(id: "osaka", name: "Осака", country: "Япония", flag: "🇯🇵", region: .asia, latitude: 34.6937, longitude: 135.5023),
        City(id: "seoul", name: "Сеул", country: "Южная Корея", flag: "🇰🇷", region: .asia, latitude: 37.5665, longitude: 126.9780),
        City(id: "hong-kong", name: "Гонконг", country: "Гонконг", flag: "🇭🇰", region: .asia, latitude: 22.3193, longitude: 114.1694),
        City(id: "taipei", name: "Тайбэй", country: "Тайвань", flag: "🇹🇼", region: .asia, latitude: 25.0330, longitude: 121.5654),
        City(id: "ho-chi-minh", name: "Хошимин", country: "Вьетнам", flag: "🇻🇳", region: .asia, latitude: 10.8231, longitude: 106.6297),
        City(id: "hanoi", name: "Ханой", country: "Вьетнам", flag: "🇻🇳", region: .asia, latitude: 21.0278, longitude: 105.8342),
        City(id: "manila", name: "Манила", country: "Филиппины", flag: "🇵🇭", region: .asia, latitude: 14.5995, longitude: 120.9842),
        City(id: "mumbai", name: "Мумбаи", country: "Индия", flag: "🇮🇳", region: .asia, latitude: 19.0760, longitude: 72.8777),
        City(id: "delhi", name: "Дели", country: "Индия", flag: "🇮🇳", region: .asia, latitude: 28.6139, longitude: 77.2090),

        // North America
        City(id: "new-york", name: "Нью-Йорк", country: "США", flag: "🇺🇸", region: .northAmerica, latitude: 40.7128, longitude: -74.0060),
        City(id: "los-angeles", name: "Лос-Анджелес", country: "США", flag: "🇺🇸", region: .northAmerica, latitude: 34.0522, longitude: -118.2437),
        City(id: "miami", name: "Майами", country: "США", flag: "🇺🇸", region: .northAmerica, latitude: 25.7617, longitude: -80.1918),
        City(id: "san-francisco", name: "Сан-Франциско", country: "США", flag: "🇺🇸", region: .northAmerica, latitude: 37.7749, longitude: -122.4194),
        City(id: "chicago", name: "Чикаго", country: "США", flag: "🇺🇸", region: .northAmerica, latitude: 41.8781, longitude: -87.6298),
        City(id: "austin", name: "Остин", country: "США", flag: "🇺🇸", region: .northAmerica, latitude: 30.2672, longitude: -97.7431),
        City(id: "las-vegas", name: "Лас-Вегас", country: "США", flag: "🇺🇸", region: .northAmerica, latitude: 36.1699, longitude: -115.1398),
        City(id: "toronto", name: "Торонто", country: "Канада", flag: "🇨🇦", region: .northAmerica, latitude: 43.6532, longitude: -79.3832),
        City(id: "vancouver", name: "Ванкувер", country: "Канада", flag: "🇨🇦", region: .northAmerica, latitude: 49.2827, longitude: -123.1207),
        City(id: "montreal", name: "Монреаль", country: "Канада", flag: "🇨🇦", region: .northAmerica, latitude: 45.5019, longitude: -73.5674),
        City(id: "mexico-city", name: "Мехико", country: "Мексика", flag: "🇲🇽", region: .northAmerica, latitude: 19.4326, longitude: -99.1332),
        City(id: "cancun", name: "Канкун", country: "Мексика", flag: "🇲🇽", region: .northAmerica, latitude: 21.1619, longitude: -86.8515),

        // Latin America
        City(id: "buenos-aires", name: "Буэнос-Айрес", country: "Аргентина", flag: "🇦🇷", region: .latinAmerica, latitude: -34.6037, longitude: -58.3816),
        City(id: "rio", name: "Рио-де-Жанейро", country: "Бразилия", flag: "🇧🇷", region: .latinAmerica, latitude: -22.9068, longitude: -43.1729),
        City(id: "sao-paulo", name: "Сан-Паулу", country: "Бразилия", flag: "🇧🇷", region: .latinAmerica, latitude: -23.5505, longitude: -46.6333),
        City(id: "medellin", name: "Медельин", country: "Колумбия", flag: "🇨🇴", region: .latinAmerica, latitude: 6.2442, longitude: -75.5812),
        City(id: "bogota", name: "Богота", country: "Колумбия", flag: "🇨🇴", region: .latinAmerica, latitude: 4.7110, longitude: -74.0721),
        City(id: "cartagena", name: "Картахена", country: "Колумбия", flag: "🇨🇴", region: .latinAmerica, latitude: 10.3910, longitude: -75.4794),
        City(id: "lima", name: "Лима", country: "Перу", flag: "🇵🇪", region: .latinAmerica, latitude: -12.0464, longitude: -77.0428),
        City(id: "santiago", name: "Сантьяго", country: "Чили", flag: "🇨🇱", region: .latinAmerica, latitude: -33.4489, longitude: -70.6693),
        City(id: "montevideo", name: "Монтевидео", country: "Уругвай", flag: "🇺🇾", region: .latinAmerica, latitude: -34.9011, longitude: -56.1645),
        City(id: "panama-city", name: "Панама", country: "Панама", flag: "🇵🇦", region: .latinAmerica, latitude: 8.9824, longitude: -79.5199),
        City(id: "san-jose", name: "Сан-Хосе", country: "Коста-Рика", flag: "🇨🇷", region: .latinAmerica, latitude: 9.9281, longitude: -84.0907),

        // Oceania
        City(id: "sydney", name: "Сидней", country: "Австралия", flag: "🇦🇺", region: .oceania, latitude: -33.8688, longitude: 151.2093),
        City(id: "melbourne", name: "Мельбурн", country: "Австралия", flag: "🇦🇺", region: .oceania, latitude: -37.8136, longitude: 144.9631),
        City(id: "brisbane", name: "Брисбен", country: "Австралия", flag: "🇦🇺", region: .oceania, latitude: -27.4698, longitude: 153.0251),
        City(id: "perth", name: "Перт", country: "Австралия", flag: "🇦🇺", region: .oceania, latitude: -31.9523, longitude: 115.8613),
        City(id: "auckland", name: "Окленд", country: "Новая Зеландия", flag: "🇳🇿", region: .oceania, latitude: -36.8509, longitude: 174.7645),
    ]

    static var defaultCity: City {
        city(withID: defaultCityID) ?? cities[0]
    }

    static func city(withID id: String) -> City? {
        cities.first { $0.id == id }
    }

    static func sections(matching query: String) -> [CitySection] {
        CityRegion.allCases.compactMap { region in
            let matches = cities.filter { city in
                city.region == region && city.matches(query)
            }
            return matches.isEmpty ? nil : CitySection(region: region, cities: matches)
        }
    }
}
