struct KeeperConfiguration: Codable, Equatable, Sendable {
    let cityID: String
    let cityName: String
    let country: String
    let latitude: Double
    let longitude: Double
    let retrySeconds: Int
    let refreshSeconds: Int
    let requestID: String
}
