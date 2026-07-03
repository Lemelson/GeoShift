import Testing
import Foundation
@testable import GeoShift

@Suite("Keeper status parsing")
struct StatusParserTests {
    @Test("Stopped when launchd service is absent")
    func stopped() {
        #expect(StatusParser.state(launchctlOutput: "", logs: "") == .stopped)
    }

    @Test("Active after a successful location refresh")
    func active() {
        let state = StatusParser.state(
            launchctlOutput: "state = running",
            logs: "Location Keeper started\nLocation set: Belgrade, Serbia"
        )
        #expect(state == .active)
    }

    @Test("Waiting when iPhone is disconnected")
    func waiting() {
        let state = StatusParser.state(
            launchctlOutput: "state = running",
            logs: "Location Keeper started\niPhone is not connected; waiting 3 seconds"
        )
        #expect(state == .waiting)
    }

    @Test("Only the current keeper session affects status")
    func currentSessionWins() {
        let state = StatusParser.state(
            launchctlOutput: "state = running",
            logs: """
            Location Keeper started
            Location set: Belgrade, Serbia
            Location Keeper started
            iPhone is not connected; waiting 3 seconds
            """
        )
        #expect(state == .waiting)
    }

    @Test("LaunchAgent receives a decoded file-system path")
    func launchAgentPathIsNotPercentEncoded() throws {
        let keeperURL = try #require(
            URL(string: "file:///Applications/GeoShift.app/Contents/Resources/keeper.py")
        )
        let arguments = LaunchAgentConfiguration.programArguments(
            pythonPath: "/tmp/python",
            keeperURL: keeperURL
        )

        #expect(arguments.last == "/Applications/GeoShift.app/Contents/Resources/keeper.py")
        #expect(arguments.last?.contains("%20") == false)
    }
}
