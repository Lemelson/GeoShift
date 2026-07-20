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
            requestID: "test-request",
            simulationEnabled: false,
            appHeartbeatAt: 1_234
        )

        let data = try JSONEncoder().encode(configuration)
        let decoded = try JSONDecoder().decode(KeeperConfiguration.self, from: data)

        #expect(decoded == configuration)
    }

    @Test("Legacy configuration defaults to an enabled simulation")
    func legacyDecode() throws {
        let data = Data(#"{"cityID":"belgrade","cityName":"Белград","country":"Сербия","latitude":44.8125,"longitude":20.4612,"retrySeconds":5,"refreshSeconds":10,"requestID":"legacy"}"#.utf8)
        let decoded = try JSONDecoder().decode(KeeperConfiguration.self, from: data)

        #expect(decoded.simulationEnabled)
        #expect(decoded.appHeartbeatAt == nil)
    }
}
