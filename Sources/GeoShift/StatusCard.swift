import SwiftUI

struct StatusCard: View {
    let state: KeeperState
    let detail: String

    @Environment(LocalizationStore.self) private var localization
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPulsing = false

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                if state == .working {
                    ProgressView()
                        .controlSize(.regular)
                } else {
                    Image(systemName: state.systemImage)
                        .font(.title)
                        .foregroundStyle(state.color)
                        .contentTransition(.symbolEffect(.replace))
                }
            }
            .frame(width: 40, height: 40)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(state.title(using: localization))
                    .font(.title2)
                    .bold()
                Text(detail)
                    .foregroundStyle(.secondary)
                    .contentTransition(.opacity)
            }
            .animation(.default, value: state)

            Spacer()

            statusDot
        }
        .padding(18)
        .background(.quaternary, in: .rect(cornerRadius: 14))
    }

    private var statusDot: some View {
        Circle()
            .fill(state.color)
            .frame(width: 12, height: 12)
            .background {
                if state == .active && !reduceMotion {
                    Circle()
                        .stroke(state.color, lineWidth: 2)
                        .scaleEffect(isPulsing ? 2.4 : 1)
                        .opacity(isPulsing ? 0 : 0.8)
                        .animation(
                            .easeOut(duration: 1.4).repeatForever(autoreverses: false),
                            value: isPulsing
                        )
                }
            }
            .onAppear {
                isPulsing = true
            }
            .accessibilityLabel(state.title(using: localization))
    }
}
