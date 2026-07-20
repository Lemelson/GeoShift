import SwiftUI

struct CityRowView: View {
    let city: City
    let isSelected: Bool
    @Environment(LocalizationStore.self) private var localization

    var body: some View {
        HStack(spacing: 12) {
            Text(city.flag)
                .font(.title2)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(city.localizedName(for: localization.language))
                Text(city.localizedCountry(for: localization.language))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .accessibilityLabel(localization.text("city.selected"))
            }
        }
        .contentShape(.rect)
    }
}
