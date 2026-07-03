import SwiftUI

struct LogPanel: View {
    let logs: String

    var body: some View {
        GroupBox("Logs") {
            if logs.isEmpty {
                ContentUnavailableView(
                    "Журнал пока пуст",
                    systemImage: "doc.text"
                )
                .frame(maxWidth: .infinity, minHeight: 180)
            } else {
                ScrollView {
                    Text(logs)
                        .font(.system(.footnote, design: .monospaced))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                }
                .defaultScrollAnchor(.bottom)
                .frame(minHeight: 180)
            }
        }
    }
}
