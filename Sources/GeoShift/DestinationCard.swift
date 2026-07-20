import MapKit
import SwiftUI

struct DestinationCard: View {
    let city: City
    let chooseAction: () -> Void
    @Environment(LocalizationStore.self) private var localization

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
    }

    private var cameraPosition: MapCameraPosition {
        .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Text(city.flag)
                    .font(.largeTitle)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text(city.localizedName(for: localization.language))
                        .font(.title2)
                        .bold()
                    Text("\(city.localizedCountry(for: localization.language)) · \(city.region.title(using: localization))")
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Button(
                        localization.text("city.choose"),
                        systemImage: "globe.europe.africa",
                        action: chooseAction
                    )

                    Text(coordinateText)
                        .font(.caption.monospaced())
                        .foregroundStyle(.tertiary)
                        .textSelection(.enabled)
                }
            }
            .padding(16)

            Map(position: .constant(cameraPosition), interactionModes: []) {
                Marker(city.localizedName(for: localization.language), coordinate: coordinate)
                    .tint(.red)
            }
            .frame(height: 150)
            .allowsHitTesting(false)
            .id(city.id)
            .accessibilityHidden(true)
        }
        .background(.quaternary, in: .rect(cornerRadius: 14))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var coordinateText: String {
        let precision = FloatingPointFormatStyle<Double>.number
            .precision(.fractionLength(4))
        return "\(city.latitude.formatted(precision)), \(city.longitude.formatted(precision))"
    }
}
