import Foundation
import Testing
@testable import GeoShift

@Suite("Log reader")
struct LogReaderTests {
    @Test("Only the requested number of recent log lines is returned")
    func limitsLines() throws {
        let url = FileManager.default.temporaryDirectory
            .appending(path: "geoshift-log-reader-\(UUID().uuidString).log")
        defer { try? FileManager.default.removeItem(at: url) }

        let source = (1...80).map { "event \($0)" }.joined(separator: "\n")
        try source.write(to: url, atomically: true, encoding: .utf8)

        let result = LogReader.tail(of: url, maximumLines: 50)
        let lines = result.split(separator: "\n")

        #expect(lines.count == 50)
        #expect(lines.first == "event 31")
        #expect(lines.last == "event 80")
    }
}
