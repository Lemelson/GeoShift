import SwiftUI

struct HeaderView: View {
    let settingsAction: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("GeoShift")
                    .font(.largeTitle)
                    .bold()
                Text("Управление симуляцией GPS для подключённого iPhone")
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(
                "Настройки",
                systemImage: "gearshape",
                action: settingsAction
            )
        }
    }
}
