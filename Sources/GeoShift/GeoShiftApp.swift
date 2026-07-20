import SwiftUI

@main
struct GeoShiftApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var controller: KeeperController
    @State private var localization: LocalizationStore

    init() {
        let localization = LocalizationStore()
        _localization = State(initialValue: localization)
        _controller = State(initialValue: KeeperController(localization: localization))
    }

    var body: some Scene {
        WindowGroup("GeoShift") {
            ContentView(controller: controller)
                .environment(localization)
                .environment(\.locale, localization.language.locale)
                .frame(minWidth: 680, minHeight: 680)
                .onAppear {
                    appDelegate.controller = controller
                }
        }
        .defaultSize(width: 760, height: 820)
        .windowResizability(.contentMinSize)
    }
}
