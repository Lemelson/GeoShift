import SwiftUI

struct HeaderView: View {
    let settingsAction: () -> Void
    @Environment(LocalizationStore.self) private var localization

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("GeoShift")
                    .font(.largeTitle)
                    .bold()
                Text(localization.text("header.subtitle"))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(
                localization.text("header.settings"),
                systemImage: "gearshape",
                action: settingsAction
            )
        }
    }
}
