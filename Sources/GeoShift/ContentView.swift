import SwiftUI

struct ContentView: View {
    @Bindable var controller: KeeperController
    @Environment(LocalizationStore.self) private var localization
    @State private var isCityPickerPresented = false
    @State private var isSettingsPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HeaderView(settingsAction: showSettings)
                DestinationCard(
                    city: controller.selectedCity,
                    chooseAction: showCityPicker
                )
                StatusCard(
                    state: controller.state,
                    detail: controller.detail
                )
                ControlBar(controller: controller)

                if controller.state == .waiting || controller.state == .restoring {
                    ConnectionHelpView(controller: controller)
                }

                if let errorMessage = controller.errorMessage {
                    ErrorBanner(message: errorMessage)
                }

                LogPanel(logs: controller.logs)

                Text(localization.text("content.safetyFootnote"))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
        }
        .sheet(isPresented: $isCityPickerPresented) {
            CityPickerView(controller: controller)
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsView(controller: controller)
        }
        .onChange(of: localization.language) {
            controller.languageDidChange()
        }
    }

    private func showCityPicker() {
        isCityPickerPresented = true
    }

    private func showSettings() {
        isSettingsPresented = true
    }
}
