import SwiftUI

struct ConnectionHelpView: View {
    @Bindable var controller: KeeperController

    var body: some View {
        PairingGuideView(controller: controller)
            .padding(14)
            .background(.orange.opacity(0.08), in: .rect(cornerRadius: 10))
    }
}
