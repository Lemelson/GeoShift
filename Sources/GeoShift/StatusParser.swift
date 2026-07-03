enum StatusParser {
    static func state(launchctlOutput: String, logs: String) -> KeeperState {
        guard launchctlOutput.contains("state = running") ||
                launchctlOutput.contains("state = spawn scheduled") else {
            return .stopped
        }

        let currentSession = logs.components(separatedBy: "Location Keeper started").last ?? logs

        if currentSession.contains("Location set:") ||
            currentSession.contains("Belgrade location refreshed") {
            return .active
        }

        if currentSession.contains("iPhone is not connected") ||
            currentSession.contains("DeviceNotFoundError") {
            return .waiting
        }

        if currentSession.contains("ERROR") ||
            currentSession.contains("forcing a clean process restart") {
            return .failed
        }

        return .working
    }
}
