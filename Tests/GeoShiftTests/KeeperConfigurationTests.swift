import Foundation
import Testing
@testable import GeoShift

@Suite("Keeper configuration")
struct KeeperConfigurationTests {
    @Test("Configuration preserves destination and timing values")
    func roundTrip() throws {
        let configuration = KeeperConfiguration(
            cityID: "phuket",
            cityName: "Пхукет",
            country: "Таиланд",
            latitude: 7.8804,
            longitude: 98.3923,
            retrySeconds: 2,
            refreshSeconds: 5,
            requestID: "test-request"
        )

        let data = try JSONEncoder().encode(configuration)
        let decoded = try JSONDecoder().decode(KeeperConfiguration.self, from: data)

        #expect(decoded == configuration)
    }
}
