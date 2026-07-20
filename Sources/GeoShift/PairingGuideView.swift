import SwiftUI

struct PairingGuideView: View {
    @Bindable var controller: KeeperController
    @Environment(LocalizationStore.self) private var localization

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(localization.text("pairing.title"), systemImage: "wifi")
                .font(.headline)

            if controller.isPairing {
                livePairingContent
            } else if controller.pairingStatus?.phase == .failed {
                failedContent
            } else if controller.hasWirelessPairing {
                pairedContent
            } else {
                unpairedContent
            }

            Text(localization.text("pairing.fallback"))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var livePairingContent: some View {
        if let code = controller.pairingStatus?.code {
            Text(code)
                .font(.system(.title, design: .monospaced, weight: .bold))
                .textSelection(.enabled)
                .accessibilityLabel("\(localization.text("pairing.codeAccessibility")): \(code.map(String.init).joined(separator: ", "))")
        } else {
            ProgressView()
                .controlSize(.small)
        }
        Text(pairingProgressMessage)
            .foregroundStyle(.secondary)
        pairingInstructions
    }

    private var pairedContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(localization.text("pairing.saved"), systemImage: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text(localization.text("pairing.frequency"))
                .font(.callout)
            HStack {
                Button(localization.text("pairing.check"), systemImage: "arrow.clockwise", action: controller.refreshAction)
                    .buttonStyle(.borderedProminent)
                Button(localization.text("pairing.recreate"), action: controller.startPairingAction)
                    .buttonStyle(.bordered)
            }
        }
    }

    private var failedContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(
                localization.text("pairing.failed"),
                systemImage: "exclamationmark.triangle.fill"
            )
            .foregroundStyle(.red)
            pairingInstructions
            Button(localization.text("pairing.retry"), systemImage: "arrow.clockwise", action: controller.startPairingAction)
                .buttonStyle(.borderedProminent)
        }
    }

    private var unpairedContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(localization.text("pairing.missing"), systemImage: "exclamationmark.circle")
                .foregroundStyle(.orange)
            pairingInstructions
            Button(
                localization.text("pairing.setup"),
                systemImage: "iphone.and.arrow.forward",
                action: controller.startPairingAction
            )
            .buttonStyle(.borderedProminent)
        }
    }

    private var pairingInstructions: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(localization.text("pairing.step1"))
            Text(localization.text("pairing.step2"))
            Text(localization.text("pairing.step3"))
            Text(localization.text("pairing.step4"))
        }
        .font(.callout)
    }

    private var pairingProgressMessage: String {
        switch controller.pairingStatus?.phase {
        case .advertising:
            localization.text("controller.pairingStarting")
        case .codeReady:
            localization.text("pairing.step3")
        default:
            localization.text("pairing.waiting")
        }
    }
}
