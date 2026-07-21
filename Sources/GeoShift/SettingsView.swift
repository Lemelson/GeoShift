import SwiftUI

struct SettingsView: View {
    @Bindable var controller: KeeperController
    @Environment(\.dismiss) private var dismiss
    @Environment(LocalizationStore.self) private var localization

    var body: some View {
        NavigationStack {
            Form {
                Section(localization.text("settings.languageSection")) {
                    LabeledContent(localization.text("settings.language")) {
                        LanguagePicker()
                    }
                }

                Section(localization.text("settings.timings")) {
                    Picker(
                        localization.text("settings.retry"),
                        selection: $controller.retrySeconds
                    ) {
                        durationOption(2)
                        durationOption(5)
                        durationOption(10)
                        durationOption(30)
                    }

                    Picker(
                        localization.text("settings.refresh"),
                        selection: $controller.locationRefreshSeconds
                    ) {
                        durationOption(5)
                        durationOption(10)
                        durationOption(15)
                        durationOption(30)
                        durationOption(60)
                    }
                }

                Section(localization.text("settings.safetySection")) {
                    Label(localization.text("settings.safetyQuit"), systemImage: "power")
                    Label(localization.text("settings.safetyHeartbeat"), systemImage: "heart.text.square")
                    Label(localization.text("settings.safetyQueue"), systemImage: "checklist")
                }

                Section(localization.text("settings.connection")) {
                    PairingGuideView(controller: controller)
                }

                Section(localization.text("settings.changesSection")) {
                    Label(localization.text("settings.changesCoordinates"), systemImage: "location.fill")
                    Label(localization.text("settings.changesPersistence"), systemImage: "iphone.and.arrow.forward")
                    Label(localization.text("settings.changesIP"), systemImage: "network")
                    Label(localization.text("settings.changesVPN"), systemImage: "shield.lefthalf.filled")
                    Label(localization.text("settings.changesDetection"), systemImage: "exclamationmark.triangle")
                }
            }
            .formStyle(.grouped)
            .navigationTitle(localization.text("settings.title"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(localization.text("common.close"), action: dismiss.callAsFunction)
                }
            }
        }
        .frame(minWidth: 580, minHeight: 460)
        .onChange(of: controller.retrySeconds) {
            controller.applySettings()
        }
        .onChange(of: controller.locationRefreshSeconds) {
            controller.applySettings()
        }
    }

    private func durationOption(_ seconds: Int) -> some View {
        Text("\(seconds) \(localization.text("unit.secondsShort"))").tag(seconds)
    }
}
