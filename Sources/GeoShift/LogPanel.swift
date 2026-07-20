import SwiftUI

struct LogPanel: View {
    let logs: String
    @State private var isExpanded = false
    @Environment(LocalizationStore.self) private var localization

    var body: some View {
        GroupBox {
            DisclosureGroup(isExpanded: $isExpanded) {
                if logs.isEmpty {
                    ContentUnavailableView(
                        localization.text("logs.empty"),
                        systemImage: "doc.text"
                    )
                    .frame(maxWidth: .infinity, minHeight: 120)
                } else {
                    ScrollView {
                        Text(logs)
                            .font(.system(.footnote, design: .monospaced))
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 10)
                    }
                    .defaultScrollAnchor(.bottom)
                    .frame(maxHeight: 220)
                }
            } label: {
                Label(localization.text("logs.title"), systemImage: "stethoscope")
            }
        }
    }
}
