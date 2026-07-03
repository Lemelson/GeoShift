import SwiftUI

struct CityRowView: View {
    let city: City
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(city.flag)
                .font(.title2)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(city.name)
                Text(city.country)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .accessibilityLabel("Выбрано")
            }
        }
        .contentShape(.rect)
    }
}
