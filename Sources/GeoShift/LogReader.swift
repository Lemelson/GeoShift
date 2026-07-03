import Foundation

enum LogReader {
    static func tail(of url: URL, maximumBytes: UInt64 = 64 * 1024) -> String {
        guard let handle = try? FileHandle(forReadingFrom: url) else {
            return ""
        }
        defer {
            try? handle.close()
        }

        let fileSize = (try? handle.seekToEnd()) ?? 0
        let offset = fileSize > maximumBytes ? fileSize - maximumBytes : 0
        try? handle.seek(toOffset: offset)

        guard let data = try? handle.readToEnd(), !data.isEmpty else {
            return ""
        }

        let text = String(decoding: data, as: UTF8.self)
        if offset == 0 {
            return text
        }

        return text.split(separator: "\n", omittingEmptySubsequences: false)
            .dropFirst()
            .joined(separator: "\n")
    }
}
