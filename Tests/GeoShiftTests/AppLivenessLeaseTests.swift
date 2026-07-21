import Foundation
import Testing
@testable import GeoShift

@Suite("App liveness lease")
struct AppLivenessLeaseTests {
    @Test("The lease remains held until its owner is released")
    func exclusiveLifetime() {
        let directory = FileManager.default.temporaryDirectory
            .appending(path: "GeoShift liveness tests \(UUID().uuidString)")
        let url = directory.appending(path: "gui-liveness.lock")
        defer { try? FileManager.default.removeItem(at: directory) }

        var lease = AppLivenessLease(url: url)
        #expect(lease != nil)
        #expect(AppLivenessLease(url: url) == nil)
        withExtendedLifetime(lease) {}

        lease = nil
        let replacementLease = AppLivenessLease(url: url)
        #expect(replacementLease != nil)
        withExtendedLifetime(replacementLease) {}
    }
}
