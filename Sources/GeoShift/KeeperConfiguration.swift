struct KeeperConfiguration: Codable, Equatable, Sendable {
    let cityID: String
    let cityName: String
    let country: String
    let latitude: Double
    let longitude: Double
    let retrySeconds: Int
    let refreshSeconds: Int
    let requestID: String
    let simulationEnabled: Bool
    let appHeartbeatAt: Double?

    init(
        cityID: String,
        cityName: String,
        country: String,
        latitude: Double,
        longitude: Double,
        retrySeconds: Int,
        refreshSeconds: Int,
        requestID: String,
        simulationEnabled: Bool = true,
        appHeartbeatAt: Double? = nil
    ) {
        self.cityID = cityID
        self.cityName = cityName
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.retrySeconds = retrySeconds
        self.refreshSeconds = refreshSeconds
        self.requestID = requestID
        self.simulationEnabled = simulationEnabled
        self.appHeartbeatAt = appHeartbeatAt
    }

    private enum CodingKeys: String, CodingKey {
        case cityID, cityName, country, latitude, longitude
        case retrySeconds, refreshSeconds, requestID, simulationEnabled, appHeartbeatAt
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cityID = try container.decode(String.self, forKey: .cityID)
        cityName = try container.decode(String.self, forKey: .cityName)
        country = try container.decode(String.self, forKey: .country)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        retrySeconds = try container.decode(Int.self, forKey: .retrySeconds)
        refreshSeconds = try container.decode(Int.self, forKey: .refreshSeconds)
        requestID = try container.decode(String.self, forKey: .requestID)
        simulationEnabled = try container.decodeIfPresent(Bool.self, forKey: .simulationEnabled) ?? true
        appHeartbeatAt = try container.decodeIfPresent(Double.self, forKey: .appHeartbeatAt)
    }
}
