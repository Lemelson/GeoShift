import SwiftUI

struct SettingsView: View {
    @Bindable var controller: KeeperController
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Тайминги") {
                    Picker(
                        "Повтор подключения",
                        selection: $controller.retrySeconds
                    ) {
                        Text("2 сек").tag(2)
                        Text("5 сек").tag(5)
                        Text("10 сек").tag(10)
                        Text("30 сек").tag(30)
                    }

                    Picker(
                        "Обновление GPS",
                        selection: $controller.locationRefreshSeconds
                    ) {
                        Text("5 сек").tag(5)
                        Text("10 сек").tag(10)
                        Text("15 сек").tag(15)
                        Text("30 сек").tag(30)
                        Text("60 сек").tag(60)
                    }
                }

                Section("Что меняется") {
                    Label("Подменяются только координаты Core Location на iPhone.", systemImage: "location.fill")
                    Label("IP-адрес, ping и маршрут интернета не меняются.", systemImage: "network")
                    Label("VPN — отдельный инструмент; он меняет интернет-маршрут и IP.", systemImage: "shield.lefthalf.filled")
                    Label("Некоторые приложения могут распознавать программную симуляцию.", systemImage: "exclamationmark.triangle")
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Настройки")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть", action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Применить", action: apply)
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .frame(minWidth: 580, minHeight: 460)
    }

    private func apply() {
        controller.applySettings()
        dismiss()
    }
}
