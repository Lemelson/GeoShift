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

    static func save(
        city: City,
        retrySeconds: Int,
        refreshSeconds: Int
    ) throws {
        let configuration = KeeperConfiguration(
            cityID: city.id,
            cityName: city.name,
            country: city.country,
            latitude: city.latitude,
            longitude: city.longitude,
            retrySeconds: retrySeconds,
            refreshSeconds: refreshSeconds,
            requestID: UUID().uuidString
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(configuration)

        try FileManager.default.createDirectory(
            at: AppPaths.configurationURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: AppPaths.configurationURL, options: .atomic)
    }
}
