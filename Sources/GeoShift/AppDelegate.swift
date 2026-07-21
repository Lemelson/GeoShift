import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    var controller: KeeperController?

    func applicationDidBecomeActive(_ notification: Notification) {
        controller?.refreshAfterActivation()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        guard let controller, controller.requiresClearBeforeTermination else {
            return .terminateNow
        }

        Task { @MainActor in
            let safetyHandoffSucceeded = await controller.stopBeforeQuit()
            sender.reply(toApplicationShouldTerminate: safetyHandoffSucceeded)
        }
        return .terminateLater
    }
}
