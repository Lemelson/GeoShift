import SwiftUI

@main
struct GeoShiftApp: App {
    @State private var controller = KeeperController()

    var body: some Scene {
        WindowGroup("GeoShift") {
            ContentView(controller: controller)
                .frame(minWidth: 680, minHeight: 680)
        }
        .defaultSize(width: 760, height: 820)
        .windowResizability(.contentMinSize)
    }
}
