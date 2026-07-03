import Foundation
import Observation

@MainActor
@Observable
final class KeeperController {
    private let runner = CommandRunner()
    private let label = "com.lemelson.geoshift.keeper"

    private var userID: uid_t {
        getuid()
    }

    private var domain: String {
        "gui/\(userID)"
    }

    private var serviceTarget: String {
        "\(domain)/\(label)"
    }

    private var launchAgentURL: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appending(path: "Library/LaunchAgents/\(label).plist")
    }

    private var logURL: URL {
        AppPaths.logURL
    }

    var state: KeeperState = .working
    var detail = "Проверяю фоновый сервис…"
    var logs = ""
    var isBusy = false
    var errorMessage: String?
    var selectedCity: City
    var retrySeconds: Int
    var locationRefreshSeconds: Int

    init() {
        let saved = ConfigStore.load()
        selectedCity = saved.flatMap { CityCatalog.city(withID: $0.cityID) } ?? CityCatalog.defaultCity
        retrySeconds = saved?.retrySeconds ?? 5
        locationRefreshSeconds = saved?.refreshSeconds ?? 10
    }

    func startAction() {
        Task {
            await installAndStart()
        }
    }

    func stopAction() {
        Task {
            await stop()
        }
    }

    func restartAction() {
        Task {
            await hardRestart()
        }
    }

    func refreshAction() {
        Task {
            await reconnectNow()
        }
    }

    func selectCity(_ city: City) {
        selectedCity = city
        requestImmediateUpdate(message: "Передаю координаты: \(city.name)…")
    }

    func applySettings() {
        requestImmediateUpdate(message: "Применяю новые интервалы…")
    }

    func poll() async {
        while !Task.isCancelled {
            await refreshStatus()
            try? await Task.sleep(for: .seconds(1))
        }
    }

    func installAndStart() async {
        guard !isBusy else {
            return
        }

        isBusy = true
        errorMessage = nil
        state = .working
        detail = "Устанавливаю фоновый сервис…"
        defer {
            isBusy = false
        }

        do {
            try saveConfiguration()
            try installLaunchAgent()
            _ = await runner.run("/bin/launchctl", arguments: ["bootout", serviceTarget])

            let bootstrap = await runner.run(
                "/bin/launchctl",
                arguments: ["bootstrap", domain, launchAgentURL.path()]
            )
            guard bootstrap.succeeded else {
                throw KeeperError.commandFailed(bootstrap.output)
            }

            _ = await runner.run("/bin/launchctl", arguments: ["enable", serviceTarget])
            let kickstart = await runner.run(
                "/bin/launchctl",
                arguments: ["kickstart", "-k", serviceTarget]
            )
            guard kickstart.succeeded else {
                throw KeeperError.commandFailed(kickstart.output)
            }

            try? await Task.sleep(for: .milliseconds(500))
            await refreshStatus()
        } catch {
            state = .failed
            detail = "Не удалось запустить keeper"
            errorMessage = error.localizedDescription
        }
    }

    func stop() async {
        guard !isBusy else {
            return
        }

        isBusy = true
        errorMessage = nil
        state = .working
        detail = "Останавливаю и возвращаю реальный GPS…"
        defer {
            isBusy = false
        }

        _ = await runner.run("/bin/launchctl", arguments: ["bootout", serviceTarget])
        if
            let pythonPath = DependencyLocator.pymobiledevicePython(),
            let keeperURL = Bundle.main.url(forResource: "keeper", withExtension: "py")
        {
            _ = await runner.run(pythonPath, arguments: [keeperURL.path(), "--clear"])
        }

        state = .stopped
        detail = "Используется реальная геопозиция"
        refreshLogs()
    }

    func hardRestart() async {
        guard !isBusy else {
            return
        }

        let status = await runner.run("/bin/launchctl", arguments: ["print", serviceTarget])
        guard status.succeeded else {
            await installAndStart()
            return
        }

        isBusy = true
        errorMessage = nil
        state = .working
        detail = "Полностью перезапускаю developer‑туннель…"

        do {
            try saveConfiguration()
            let result = await runner.run(
                "/bin/launchctl",
                arguments: ["kickstart", "-k", serviceTarget]
            )
            guard result.succeeded else {
                throw KeeperError.commandFailed(result.output)
            }
        } catch {
            errorMessage = error.localizedDescription
            state = .failed
        }

        isBusy = false
        try? await Task.sleep(for: .milliseconds(500))
        await refreshStatus()
    }

    func reconnectNow() async {
        guard !isBusy else {
            return
        }

        let status = await runner.run("/bin/launchctl", arguments: ["print", serviceTarget])
        guard status.succeeded else {
            await installAndStart()
            return
        }

        isBusy = true
        errorMessage = nil
        state = .working
        detail = "Немедленная попытка подключения…"

        do {
            try saveConfiguration()
            try? await Task.sleep(for: .milliseconds(350))
        } catch {
            errorMessage = error.localizedDescription
            state = .failed
        }

        isBusy = false
        await refreshStatus()
    }

    func refreshStatus() async {
        guard !isBusy else {
            return
        }

        let status = await runner.run("/bin/launchctl", arguments: ["print", serviceTarget])
        refreshLogs()

        guard status.succeeded else {
            state = .stopped
            detail = "Используется реальная геопозиция"
            return
        }

        state = StatusParser.state(launchctlOutput: status.output, logs: logs)
        detail = switch state {
        case .stopped:
            "Используется реальная геопозиция"
        case .waiting:
            "macOS не видит iPhone по USB или локальной Wi‑Fi‑сети"
        case .active:
            "\(selectedCity.name), \(selectedCity.country) · GPS каждые \(locationRefreshSeconds) сек"
        case .working:
            "Фоновый сервис запускается"
        case .failed:
            "Нажмите Restart; подробности находятся ниже"
        }
    }

    private func requestImmediateUpdate(message: String) {
        errorMessage = nil
        state = .working
        detail = message

        do {
            try saveConfiguration()
        } catch {
            state = .failed
            errorMessage = error.localizedDescription
            return
        }

        Task {
            try? await Task.sleep(for: .milliseconds(500))
            await refreshStatus()
        }
    }

    private func refreshLogs() {
        logs = LogReader.tail(of: logURL)
    }

    private func saveConfiguration() throws {
        try ConfigStore.save(
            city: selectedCity,
            retrySeconds: retrySeconds,
            refreshSeconds: locationRefreshSeconds
        )
    }

    private func installLaunchAgent() throws {
        guard let pythonPath = DependencyLocator.pymobiledevicePython() else {
            throw KeeperError.missingDependency("pymobiledevice3")
        }

        guard let keeperURL = Bundle.main.url(forResource: "keeper", withExtension: "py") else {
            throw KeeperError.missingKeeper
        }

        let logPath = logURL.path()
        let propertyList: [String: Any] = [
            "Label": label,
            "ProgramArguments": LaunchAgentConfiguration.programArguments(
                pythonPath: pythonPath,
                keeperURL: keeperURL
            ),
            "RunAtLoad": true,
            "KeepAlive": true,
            "ThrottleInterval": 5,
            "StandardOutPath": logPath,
            "StandardErrorPath": logPath,
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
}
