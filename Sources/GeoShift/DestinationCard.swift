import SwiftUI

struct DestinationCard: View {
    let city: City
    let chooseAction: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Text(city.flag)
                .font(.largeTitle)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(city.name)
                    .font(.title2)
                    .bold()
                Text(city.subtitle)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(
                "Выбрать город",
                systemImage: "globe.europe.africa",
                action: chooseAction
            )
        }
        .padding(16)
        .background(.quaternary, in: .rect(cornerRadius: 14))
    }
}
