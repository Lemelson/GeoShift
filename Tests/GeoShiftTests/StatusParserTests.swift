import Foundation
import Testing
@testable import GeoShift

@Suite("Keeper status parsing")
struct StatusParserTests {
    private let enabled = KeeperConfiguration(
        cityID: "belgrade",
        cityName: "Белград",
        country: "Сербия",
        latitude: 44.8125,
        longitude: 20.4612,
        retrySeconds: 5,
        refreshSeconds: 10,
        requestID: "request",
        simulationEnabled: true
    )

    @Test("A missing configuration never proves real GPS")
    func missingConfigurationIsUnknown() {
        #expect(StatusParser.state(
            launchctlOutput: "",
            configuration: nil,
            workerStatus: status(.active, mayBeActive: true)
        ) == .failed)
    }

    @Test("An absent service never proves real GPS for an enabled request")
    func absentServiceIsUnknown() {
        #expect(StatusParser.state(
            launchctlOutput: "",
            configuration: enabled,
            workerStatus: status(.active, mayBeActive: true)
        ) == .failed)
    }

    @Test("Only a matching successful clear status marks simulation inactive")
    func matchingSuccessfulClearStatus() {
        let disabled = configuration(enabled: false)

        #expect(StatusParser.state(
            launchctlOutput: "",
            configuration: disabled,
            workerStatus: status(.cleared, mayBeActive: false)
        ) == .stopped)
    }

    @Test("A failed or stale clear remains pending")
    func clearRemainsPending() {
        let disabled = configuration(enabled: false)
        let stale = WorkerStatus(
            phase: .cleared,
            requestID: "old-request",
            deviceUDID: "phone",
            simulationMayBeActive: false,
            message: nil,
            updatedAt: 0
        )

        #expect(StatusParser.state(
            launchctlOutput: "",
            configuration: disabled,
            workerStatus: stale
        ) == .failed)
        #expect(StatusParser.state(
            launchctlOutput: "state = running",
            configuration: disabled,
            workerStatus: status(.clearPending, mayBeActive: true)
        ) == .restoring)
    }

    @Test("Active requires the matching request and a running worker")
    func activeRequiresRunningWorker() {
        #expect(StatusParser.state(
            launchctlOutput: "state = running",
            configuration: enabled,
            workerStatus: status(.active, mayBeActive: true)
        ) == .active)
    }

    @Test("Waiting is machine-readable rather than inferred from logs")
    func waiting() {
        #expect(StatusParser.state(
            launchctlOutput: "state = running",
            configuration: enabled,
            workerStatus: status(.waitingForDevice, mayBeActive: false)
        ) == .waiting)
    }

    @Test("A stale worker heartbeat is unknown")
    func staleHeartbeat() {
        let stale = WorkerStatus(
            phase: .active,
            requestID: enabled.requestID,
            deviceUDID: "phone",
            simulationMayBeActive: true,
            message: nil,
            updatedAt: 100
        )

        #expect(StatusParser.state(
            launchctlOutput: "state = running",
            configuration: enabled,
            workerStatus: stale,
            now: 1_000
        ) == .failed)
    }

    @Test("LaunchAgent receives a decoded file-system path")
    func launchAgentPathIsNotPercentEncoded() throws {
        let keeperURL = try #require(
            URL(string: "file:///Applications/GeoShift.app/Contents/Resources/keeper.py")
        )
        let arguments = LaunchAgentConfiguration.programArguments(
            pythonPath: "/tmp/python",
            keeperURL: keeperURL
        )

        #expect(arguments.last == "/Applications/GeoShift.app/Contents/Resources/keeper.py")
        #expect(arguments.last?.contains("%20") == false)
    }

    private func configuration(enabled: Bool) -> KeeperConfiguration {
        KeeperConfiguration(
            cityID: self.enabled.cityID,
            cityName: self.enabled.cityName,
            country: self.enabled.country,
            latitude: self.enabled.latitude,
            longitude: self.enabled.longitude,
            retrySeconds: self.enabled.retrySeconds,
            refreshSeconds: self.enabled.refreshSeconds,
            requestID: self.enabled.requestID,
            simulationEnabled: enabled
        )
    }

    @Test("An incompatible backend reported for the current request is surfaced")
    func incompatibleBackendIsSurfaced() throws {
        var failed = status(.failed, mayBeActive: false)
        failed.problem = StatusParser.incompatibleBackendProblem
        var pending = status(.clearPending, mayBeActive: true)
        pending.problem = StatusParser.incompatibleBackendProblem
        var recovered = status(.active, mayBeActive: true)
        recovered.problem = StatusParser.incompatibleBackendProblem

        #expect(StatusParser.hasIncompatibleBackend(configuration: enabled, workerStatus: failed))
        #expect(StatusParser.hasIncompatibleBackend(
            configuration: configuration(enabled: false),
            workerStatus: pending
        ))
        #expect(!StatusParser.hasIncompatibleBackend(configuration: enabled, workerStatus: recovered))
        #expect(!StatusParser.hasIncompatibleBackend(
            configuration: enabled,
            workerStatus: status(.failed, mayBeActive: false)
        ))

        let otherRequest = WorkerStatus(
            phase: .failed,
            requestID: "old-request",
            deviceUDID: "phone",
            simulationMayBeActive: false,
            message: nil,
            updatedAt: 0,
            problem: StatusParser.incompatibleBackendProblem
        )
        #expect(!StatusParser.hasIncompatibleBackend(configuration: enabled, workerStatus: otherRequest))
    }

    @Test("Worker status decodes with and without a problem code")
    func problemCodeIsOptional() throws {
        let legacy = Data(#"{"phase":"failed","requestID":"request","deviceUDID":null,"simulationMayBeActive":false,"message":null,"updatedAt":1}"#.utf8)
        let current = Data(#"{"phase":"failed","requestID":"request","deviceUDID":null,"simulationMayBeActive":false,"message":"x","updatedAt":1,"problem":"incompatibleBackend"}"#.utf8)

        #expect(try JSONDecoder().decode(WorkerStatus.self, from: legacy).problem == nil)
        #expect(try JSONDecoder().decode(WorkerStatus.self, from: current).problem == "incompatibleBackend")
    }

    private func status(_ phase: WorkerStatus.Phase, mayBeActive: Bool) -> WorkerStatus {
        WorkerStatus(
            phase: phase,
            requestID: enabled.requestID,
            deviceUDID: "phone",
            simulationMayBeActive: mayBeActive,
            message: nil,
            updatedAt: Date.now.timeIntervalSince1970
        )
    }
}
