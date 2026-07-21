import SwiftUI

struct LanguagePicker: View {
    var controlSize: ControlSize = .regular
    @Environment(LocalizationStore.self) private var localization

    var body: some View {
        @Bindable var localization = localization

        Picker(
            localization.text("settings.language"),
            selection: $localization.language
        ) {
            ForEach(AppLanguage.allCases) { language in
                Text(language.selectionLabel).tag(language)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .controlSize(controlSize)
        .fixedSize()
        .accessibilityLabel(localization.text("settings.language"))
    }
}
