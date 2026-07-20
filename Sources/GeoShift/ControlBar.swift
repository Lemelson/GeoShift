import SwiftUI

struct ControlBar: View {
    let controller: KeeperController
    @Environment(LocalizationStore.self) private var localization

    var body: some View {
        HStack(spacing: 10) {
            Button(
                localization.text("control.start"),
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
                localization.text("control.restore"),
                systemImage: "stop.fill",
                action: controller.stopAction
            )
            .disabled(controller.isBusy || controller.state == .stopped)

            Button(
                localization.text("control.restart"),
                systemImage: "arrow.clockwise",
                action: controller.restartAction
            )
            .disabled(controller.isBusy || controller.state == .stopped)

            Spacer()

            Button(
                localization.text("control.refresh"),
                systemImage: "arrow.trianglehead.2.clockwise",
                action: controller.refreshAction
            )
            .disabled(controller.isBusy)
        }
        .controlSize(.large)
    }
}
