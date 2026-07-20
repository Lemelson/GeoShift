import Foundation

enum StatusParser {
    static func state(
        launchctlOutput: String,
        configuration: KeeperConfiguration?,
        workerStatus: WorkerStatus?,
        now: Double = Date.now.timeIntervalSince1970
    ) -> KeeperState {
        guard let configuration else {
            return .failed
        }

        let serviceIsRunning = launchctlOutput.contains("state = running")
        let statusMatchesRequest = workerStatus?.requestID == configuration.requestID

        if !configuration.simulationEnabled {
            if statusMatchesRequest, workerStatus?.phase == .cleared,
               workerStatus?.simulationMayBeActive == false {
                return .stopped
            }
            return serviceIsRunning ? .restoring : .failed
        }

        guard statusMatchesRequest, let workerStatus else {
            return serviceIsRunning ? .working : .failed
        }
        let maximumStatusAge = max(Double(configuration.refreshSeconds * 2), 30)
        let statusIsFresh = now - workerStatus.updatedAt <= maximumStatusAge
        guard serviceIsRunning, statusIsFresh else {
            return .failed
        }

        return switch workerStatus.phase {
        case .active:
            .active
        case .waitingForDevice:
            .waiting
        case .starting, .connecting, .applying:
            .working
        case .clearing, .clearPending:
            .restoring
        case .failed, .cleared:
            .failed
        }
    }
}
