import Foundation

enum ConfigStore {
    static func load() -> KeeperConfiguration? {
        for url in [AppPaths.configurationURL, AppPaths.legacyConfigurationURL] {
            guard let data = try? Data(contentsOf: url) else {
                continue
            }
            if let configuration = try? JSONDecoder().decode(KeeperConfiguration.self, from: data) {
                return configuration
            }
        }
        return nil
    }

    @discardableResult
    static func save(
        city: City,
        retrySeconds: Int,
        refreshSeconds: Int,
        simulationEnabled: Bool,
        requestID: String = UUID().uuidString,
        appHeartbeatAt: Double? = nil
    ) throws -> KeeperConfiguration {
        let configuration = KeeperConfiguration(
            cityID: city.id,
            cityName: city.localizedName(for: .english),
            country: city.localizedCountry(for: .english),
            latitude: city.latitude,
            longitude: city.longitude,
            retrySeconds: retrySeconds,
            refreshSeconds: refreshSeconds,
            requestID: requestID,
            simulationEnabled: simulationEnabled,
            appHeartbeatAt: appHeartbeatAt
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(configuration)

        try FileManager.default.createDirectory(
            at: AppPaths.configurationURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: AppPaths.configurationURL, options: .atomic)
        return configuration
    }
}
