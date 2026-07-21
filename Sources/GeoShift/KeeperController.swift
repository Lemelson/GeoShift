import Foundation
import Observation

@MainActor
@Observable
final class KeeperController {
    private static let heartbeatInterval: Double = 30
    private static let watchdogInterval: Double = 5 * 60

    private let localization: LocalizationStore
    private let runner = CommandRunner()
    private let pairingRunner = CommandRunner()
    private var appLivenessLease: AppLivenessLease?
    private let label = "com.lemelson.geoshift.keeper"
    private var didRecoverOnLaunch = false
    private var lastHeartbeatWrite = 0.0
    private var lastWatchdogCheck = 0.0
    private var lastLogRefresh = 0.0
    @ObservationIgnored private var monitoringTask: Task<Void, Never>?

    var state: KeeperState = .working
    var detail: String
    var logs = ""
    var isBusy = false
    var errorMessage: String?
    var selectedCity: City
    var retrySeconds: Int
    var locationRefreshSeconds: Int
    private(set) var simulationEnabled: Bool
    private(set) var pairingStatus: PairingStatus?
    private(set) var isPairing = false
    private(set) var hasWirelessPairing = PairingStatusStore.hasWirelessPairing

    var requiresClearBeforeTermination: Bool {
        if ConfigStore.load()?.simulationEnabled == true {
            return true
        }
        if WorkerStatusStore.load()?.simulationMayBeActive == true {
            return true
        }
        return state != .stopped && ConfigStore.load() != nil
    }

    private var domain: String {
        "gui/\(getuid())"
    }

    private var serviceTarget: String {
        "\(domain)/\(label)"
    }

    private var launchAgentURL: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appending(path: "Library/LaunchAgents/\(label).plist")
    }

    init(localization: LocalizationStore) {
        self.localization = localization
        appLivenessLease = AppLivenessLease(url: AppPaths.appLivenessLockURL)
        let saved = ConfigStore.load()
        selectedCity = saved.flatMap { CityCatalog.city(withID: $0.cityID) } ?? CityCatalog.defaultCity
        retrySeconds = saved?.retrySeconds ?? 5
        locationRefreshSeconds = saved?.refreshSeconds ?? 10
        simulationEnabled = saved?.simulationEnabled ?? false
        let savedPairingStatus = PairingStatusStore.load()
        if savedPairingStatus?.phase == .advertising || savedPairingStatus?.phase == .codeReady {
            pairingStatus = nil
        } else {
            pairingStatus = savedPairingStatus
        }
        detail = localization.text("controller.checkingService")
    }

    func startAction() {
        Task { await installAndStart() }
    }

    func stopAction() {
        Task { await stop() }
    }

    func restartAction() {
        Task { await hardRestart() }
    }

    func refreshAction() {
        Task { await reconnectNow() }
    }

    func startPairingAction() {
        Task { await startPairing() }
    }

    func selectCity(_ city: City) {
        selectedCity = city
        requestImmediateUpdate(
            message: "\(localization.text("controller.sendingCoordinates")) \(city.localizedName(for: localization.language))…"
        )
    }

    func applySettings() {
        requestImmediateUpdate(message: localization.text("controller.applyingSettings"))
    }

    func languageDidChange() {
        if errorMessage != nil {
            errorMessage = localization.text("error.previousOperation")
        }
        detail = statusDetail(
            state: state,
            configuration: ConfigStore.load()
        )
    }

    func startMonitoring() {
        guard monitoringTask == nil else {
            return
        }
        monitoringTask = Task { [weak self] in
            guard let self else {
                return
            }
            await monitor()
            monitoringTask = nil
        }
    }

    func refreshAfterActivation() {
        startMonitoring()
        Task { await refreshStatus() }
    }

    private func monitor() async {
        await recoverOnLaunch()

        while !Task.isCancelled {
            let now = Date.now.timeIntervalSince1970
            if simulationEnabled, now - lastHeartbeatWrite >= Self.heartbeatInterval {
                refreshHeartbeat(at: now)
            }
            if now - lastWatchdogCheck >= Self.watchdogInterval {
                lastWatchdogCheck = now
                await repairWorkerIfNeeded()
            }
            if now - lastLogRefresh >= 10 {
                lastLogRefresh = now
                refreshLogs()
            }

            pairingStatus = PairingStatusStore.load()
            hasWirelessPairing = PairingStatusStore.hasWirelessPairing
            await refreshStatus()
            try? await Task.sleep(for: .seconds(1))
        }
    }

    func installAndStart() async {
        if appLivenessLease == nil {
            appLivenessLease = AppLivenessLease(url: AppPaths.appLivenessLockURL)
        }
        guard appLivenessLease != nil else {
            state = .failed
            errorMessage = localizedDescription(for: KeeperError.missingLivenessLease)
            return
        }
        await transition(
            simulationEnabled: true,
            message: localization.text("controller.startingTunnel")
        )
    }

    func stop() async {
        if successfulClearIsRecorded() {
            await refreshStatus()
            return
        }
        if ConfigStore.load()?.simulationEnabled == false {
            await continuePendingClear()
            return
        }
        await transition(
            simulationEnabled: false,
            message: localization.text("controller.restoring")
        )
    }

    func stopBeforeQuit() async -> Bool {
        for _ in 0..<100 where isBusy {
            try? await Task.sleep(for: .milliseconds(100))
        }
        guard !isBusy else {
            errorMessage = localization.text("controller.quitBusy")
            return false
        }
        await stop()
        let handoffSucceeded = await terminationSafetyHandoffSucceeded()
        if !handoffSucceeded {
            errorMessage = localization.text("controller.quitHandoff")
        }
        return handoffSucceeded
    }

    func hardRestart() async {
        guard !isBusy else {
            return
        }
        isBusy = true
        errorMessage = nil
        state = simulationEnabled ? .working : .restoring
        detail = localization.text("controller.hardRestart")

        do {
            let requestID = ConfigStore.load()?.requestID
            let configuration = try saveConfiguration(requestID: requestID)
            try installLaunchAgent()
            try await ensureLaunchAgentRunning(forceRestart: true)
            await waitForWorkerAcknowledgement(
                requestID: configuration.requestID,
                simulationEnabled: configuration.simulationEnabled
            )
        } catch {
            state = .failed
            errorMessage = localizedDescription(for: error)
        }

        isBusy = false
        await refreshStatus()
    }

    func reconnectNow() async {
        guard !isBusy else {
            return
        }
        isBusy = true
        errorMessage = nil
        detail = localization.text("controller.reconnecting")

        do {
            let requestID = ConfigStore.load()?.requestID
            let configuration = try saveConfiguration(requestID: requestID)
            try installLaunchAgent()
            try await ensureLaunchAgentRunning(forceRestart: false)
            await waitForWorkerAcknowledgement(
                requestID: configuration.requestID,
                simulationEnabled: configuration.simulationEnabled
            )
        } catch {
            state = .failed
            errorMessage = localizedDescription(for: error)
        }

        isBusy = false
        await refreshStatus()
    }

    func refreshStatus() async {
        guard !isBusy else {
            return
        }

        let launchctl = await runner.run(
            "/bin/launchctl",
            arguments: ["print", serviceTarget]
        )
        let configuration = ConfigStore.load()
        let workerStatus = WorkerStatusStore.load()

        simulationEnabled = configuration?.simulationEnabled ?? false
        state = StatusParser.state(
            launchctlOutput: launchctl.output,
            configuration: configuration,
            workerStatus: workerStatus
        )
        detail = statusDetail(
            state: state,
            configuration: configuration
        )
    }

    private func recoverOnLaunch() async {
        guard !didRecoverOnLaunch else {
            return
        }
        didRecoverOnLaunch = true

        // Keep the on-disk LaunchAgent definition current even when the last
        // successful clear send is already recorded and no worker needs to run.
        if ConfigStore.load() != nil {
            do {
                try installLaunchAgent()
            } catch {
                state = .failed
                errorMessage = "\(localization.text("controller.watchdogUpdateFailed")): \(localizedDescription(for: error))"
            }
        }

        if ConfigStore.load()?.simulationEnabled == true {
            await transition(
                simulationEnabled: false,
                message: localization.text("controller.recoverySession")
            )
        } else {
            await repairWorkerIfNeeded()
        }
    }

    private func transition(
        simulationEnabled requestedValue: Bool,
        message: String
    ) async {
        guard !isBusy else {
            return
        }

        isBusy = true
        errorMessage = nil
        state = requestedValue ? .working : .restoring
        detail = message

        do {
            simulationEnabled = requestedValue
            let configuration = try saveConfiguration()
            try installLaunchAgent()
            // The running worker watches config.json. Do not tear down a healthy
            // tunnel during a normal Start/Stop transition.
            try await ensureLaunchAgentRunning(forceRestart: false)
            await waitForWorkerAcknowledgement(
                requestID: configuration.requestID,
                simulationEnabled: requestedValue
            )
        } catch {
            state = .failed
            detail = requestedValue
                ? localization.text("controller.startFailed")
                : localization.text("controller.restoreFailed")
            errorMessage = localizedDescription(for: error)
        }

        isBusy = false
        await refreshStatus()
    }

    private func continuePendingClear() async {
        guard !isBusy, let configuration = ConfigStore.load() else {
            return
        }
        isBusy = true
        state = .restoring
        detail = localization.text("controller.checkingQueue")
        do {
            try installLaunchAgent()
            try await ensureLaunchAgentRunning(forceRestart: false)
            await waitForWorkerAcknowledgement(
                requestID: configuration.requestID,
                simulationEnabled: false
            )
        } catch {
            state = .failed
            errorMessage = localizedDescription(for: error)
        }
        isBusy = false
        await refreshStatus()
    }

    private func requestImmediateUpdate(message: String) {
        errorMessage = nil
        detail = message

        do {
            let existingRequestID = simulationEnabled ? nil : ConfigStore.load()?.requestID
            _ = try saveConfiguration(requestID: existingRequestID)
            if simulationEnabled {
                state = .working
            }
        } catch {
            state = .failed
            errorMessage = localizedDescription(for: error)
            return
        }

        Task {
            try? await Task.sleep(for: .milliseconds(500))
            await refreshStatus()
        }
    }

    private func refreshHeartbeat(at timestamp: Double) {
        guard simulationEnabled, let requestID = ConfigStore.load()?.requestID else {
            return
        }
        do {
            _ = try saveConfiguration(requestID: requestID, heartbeatAt: timestamp)
            lastHeartbeatWrite = timestamp
        } catch {
            state = .failed
            errorMessage = "\(localization.text("controller.watchdogUpdateFailed")): \(localizedDescription(for: error))"
        }
    }

    private func repairWorkerIfNeeded() async {
        guard !isBusy, let configuration = ConfigStore.load() else {
            return
        }
        let workerStatus = WorkerStatusStore.load()
        if !configuration.simulationEnabled,
           workerStatus?.requestID == configuration.requestID,
           workerStatus?.phase == .cleared,
           workerStatus?.simulationMayBeActive == false {
            return
        }

        let launchctl = await runner.run(
            "/bin/launchctl",
            arguments: ["print", serviceTarget]
        )
        let statusAge = Date.now.timeIntervalSince1970 - (workerStatus?.updatedAt ?? 0)
        let heartbeatLimit = max(Double(configuration.refreshSeconds * 2), 30)
        let workerLooksHealthy = launchctl.output.contains("state = running")
            && workerStatus?.requestID == configuration.requestID
            && statusAge <= heartbeatLimit
        guard !workerLooksHealthy else {
            return
        }

        do {
            try installLaunchAgent()
            try await ensureLaunchAgentRunning(forceRestart: launchctl.succeeded)
        } catch {
            state = .failed
            errorMessage = "\(localization.text("controller.watchdogRepairFailed")): \(localizedDescription(for: error))"
        }
    }

    private func saveConfiguration(
        requestID: String? = nil,
        heartbeatAt: Double? = nil
    ) throws -> KeeperConfiguration {
        if simulationEnabled, appLivenessLease == nil {
            throw KeeperError.missingLivenessLease
        }
        let heartbeat = simulationEnabled
            ? heartbeatAt ?? Date.now.timeIntervalSince1970
            : nil
        if simulationEnabled {
            lastHeartbeatWrite = heartbeat ?? 0
        }
        return try ConfigStore.save(
            city: selectedCity,
            retrySeconds: retrySeconds,
            refreshSeconds: locationRefreshSeconds,
            simulationEnabled: simulationEnabled,
            requestID: requestID ?? UUID().uuidString,
            appHeartbeatAt: heartbeat
        )
    }

    private func installLaunchAgent() throws {
        guard let pythonPath = DependencyLocator.pymobiledevicePython() else {
            throw KeeperError.missingDependency("pymobiledevice3")
        }
        guard let keeperURL = Bundle.main.url(forResource: "keeper", withExtension: "py") else {
            throw KeeperError.missingKeeper
        }

        let propertyList: [String: Any] = [
            "Label": label,
            "ProgramArguments": LaunchAgentConfiguration.programArguments(
                pythonPath: pythonPath,
                keeperURL: keeperURL
            ),
            "RunAtLoad": true,
            "KeepAlive": ["SuccessfulExit": false],
            "ThrottleInterval": 5,
            "ExitTimeOut": 20,
            "StandardOutPath": "/dev/null",
            "StandardErrorPath": "/dev/null",
        ]
        let data = try PropertyListSerialization.data(
            fromPropertyList: propertyList,
            format: .xml,
            options: 0
        )

        try FileManager.default.createDirectory(
            at: launchAgentURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: launchAgentURL, options: .atomic)
    }

    private func ensureLaunchAgentRunning(forceRestart: Bool) async throws {
        let existing = await runner.run(
            "/bin/launchctl",
            arguments: ["print", serviceTarget]
        )
        if existing.output.contains("state = running"), !forceRestart {
            return
        }
        if existing.succeeded {
            let bootout = await runner.run(
                "/bin/launchctl",
                arguments: ["bootout", serviceTarget]
            )
            guard bootout.succeeded else {
                throw KeeperError.commandFailed(bootout.output)
            }
            try await waitUntilLaunchAgentIsUnloaded()
        }

        let enable = await runner.run(
            "/bin/launchctl",
            arguments: ["enable", serviceTarget]
        )
        guard enable.succeeded else {
            throw KeeperError.commandFailed(enable.output)
        }

        let bootstrap = await runner.run(
            "/bin/launchctl",
            arguments: ["bootstrap", domain, launchAgentURL.path()]
        )
        guard bootstrap.succeeded else {
            throw KeeperError.commandFailed(bootstrap.output)
        }
    }

    private func waitUntilLaunchAgentIsUnloaded() async throws {
        for _ in 0..<60 {
            let check = await runner.run(
                "/bin/launchctl",
                arguments: ["print", serviceTarget]
            )
            if !check.succeeded {
                return
            }
            try await Task.sleep(for: .milliseconds(250))
        }
        throw KeeperError.commandFailed(localization.text("controller.previousWorkerTimeout"))
    }

    private func waitForWorkerAcknowledgement(
        requestID: String,
        simulationEnabled: Bool
    ) async {
        for _ in 0..<24 {
            if let status = WorkerStatusStore.load(), status.requestID == requestID {
                if simulationEnabled {
                    if [.active, .waitingForDevice, .failed].contains(status.phase) {
                        return
                    }
                } else if [.cleared, .clearPending, .failed].contains(status.phase) {
                    return
                }
            }
            try? await Task.sleep(for: .milliseconds(250))
        }
    }

    private func successfulClearIsRecorded() -> Bool {
        guard let configuration = ConfigStore.load(),
              let status = WorkerStatusStore.load() else {
            return false
        }
        return !configuration.simulationEnabled
            && status.requestID == configuration.requestID
            && status.phase == .cleared
            && !status.simulationMayBeActive
    }

    private func terminationSafetyHandoffSucceeded() async -> Bool {
        guard let configuration = ConfigStore.load(),
              !configuration.simulationEnabled,
              let status = WorkerStatusStore.load(),
              status.requestID == configuration.requestID else {
            return false
        }
        if status.phase == .cleared, !status.simulationMayBeActive {
            return true
        }
        guard status.phase == .clearPending || status.phase == .clearing else {
            return false
        }
        let launchctl = await runner.run(
            "/bin/launchctl",
            arguments: ["print", serviceTarget]
        )
        return launchctl.output.contains("state = running")
    }

    private func startPairing() async {
        guard !isPairing else {
            return
        }
        guard let pythonPath = DependencyLocator.pymobiledevicePython(),
              let helperURL = Bundle.main.url(forResource: "pairing", withExtension: "py") else {
            errorMessage = localization.text("controller.pairingModuleMissing")
            return
        }

        try? FileManager.default.removeItem(at: AppPaths.pairingStatusURL)
        errorMessage = nil
        pairingStatus = PairingStatus(
            phase: .advertising,
            code: nil,
            deviceUDID: nil,
            message: localization.text("controller.pairingStarting"),
            updatedAt: Date.now.timeIntervalSince1970
        )
        isPairing = true

        let result = await pairingRunner.run(
            pythonPath,
            arguments: [helperURL.path()],
            timeoutSeconds: 190
        )
        pairingStatus = PairingStatusStore.load()
        hasWirelessPairing = PairingStatusStore.hasWirelessPairing
        isPairing = false

        if pairingStatus?.phase == .paired {
            errorMessage = nil
            await reconnectNow()
        } else if !result.succeeded {
            errorMessage = localization.text("pairing.failed")
        }
    }

    private func statusDetail(
        state: KeeperState,
        configuration: KeeperConfiguration?
    ) -> String {
        return switch state {
        case .stopped:
            localization.text("status.cleared")
        case .restoring:
            localization.text("status.restorePending")
        case .waiting:
            localization.text("status.phoneUnavailable")
        case .active:
            if let configuration,
               let city = CityCatalog.city(withID: configuration.cityID) {
                "\(city.localizedName(for: localization.language)), \(city.localizedCountry(for: localization.language)) · \(localization.text("status.gpsEvery")) \(configuration.refreshSeconds) \(localization.text("unit.secondsShort"))"
            } else {
                localization.text("status.active")
            }
        case .working:
            localization.text("status.connecting")
        case .failed:
            localization.text("status.notConfirmed")
        }
    }

    private func refreshLogs() {
        logs = LogReader.tail(of: AppPaths.logURL)
    }

    private func localizedDescription(for error: Error) -> String {
        if let keeperError = error as? KeeperError {
            return keeperError.description(using: localization)
        }
        return error.localizedDescription
    }
}
