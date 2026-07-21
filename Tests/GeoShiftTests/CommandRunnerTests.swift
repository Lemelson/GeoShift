import Foundation
import Testing
@testable import GeoShift

@Suite("Command runner")
struct CommandRunnerTests {
    @Test("A timed-out process cannot strand the next command")
    func timeoutDoesNotStrandRunner() async {
        let runner = CommandRunner()
        let clock = ContinuousClock()
        let startedAt = clock.now

        let timedOut = await runner.run(
            "/bin/sh",
            arguments: ["-c", "trap '' TERM; exec /bin/sleep 30"],
            timeoutSeconds: 0.2
        )
        let elapsed = startedAt.duration(to: clock.now)

        #expect(timedOut.status == -2)
        #expect(elapsed < .seconds(1))

        let followUp = await runner.run(
            "/usr/bin/true",
            arguments: [],
            timeoutSeconds: 1
        )
        #expect(followUp.succeeded)
    }

    @Test("A launch failure is returned without stranding the runner")
    func launchFailureDoesNotStrandRunner() async {
        let runner = CommandRunner()

        let failed = await runner.run(
            "/GeoShift/does-not-exist",
            arguments: [],
            timeoutSeconds: 1
        )
        #expect(failed.status == -1)

        let followUp = await runner.run(
            "/usr/bin/true",
            arguments: [],
            timeoutSeconds: 1
        )
        #expect(followUp.succeeded)
    }
}
