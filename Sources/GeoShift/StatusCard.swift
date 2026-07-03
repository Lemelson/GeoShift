import SwiftUI

struct StatusCard: View {
    let state: KeeperState
    let detail: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: state.systemImage)
                .font(.title)
                .foregroundStyle(state.color)
                .frame(width: 40, height: 40)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(state.title)
                    .font(.title2)
                    .bold()
                Text(detail)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Circle()
                .fill(state.color)
                .frame(width: 12, height: 12)
                .accessibilityLabel(state.title)
        }
        .padding(18)
        .background(.quaternary, in: .rect(cornerRadius: 14))
    }
}
