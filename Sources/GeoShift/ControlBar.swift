import SwiftUI

struct ControlBar: View {
    let controller: KeeperController

    var body: some View {
        HStack(spacing: 10) {
            Button(
                "Start",
                systemImage: "play.fill",
                action: controller.startAction
            )
            .buttonStyle(.borderedProminent)
            .disabled(
                controller.isBusy ||
                    controller.state == .active ||
                    controller.state == .waiting ||
                    controller.state == .working
            )

            Button(
                "Stop",
                systemImage: "stop.fill",
                action: controller.stopAction
            )
            .disabled(controller.isBusy || controller.state == .stopped)

            Button(
                "Restart",
                systemImage: "arrow.clockwise",
                action: controller.restartAction
            )
            .disabled(controller.isBusy || controller.state == .stopped)

            Spacer()

            Button(
                "Refresh",
                systemImage: "arrow.trianglehead.2.clockwise",
                action: controller.refreshAction
            )
            .disabled(controller.isBusy)
        }
        .controlSize(.large)
    }
}
