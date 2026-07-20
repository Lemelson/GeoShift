import Foundation

enum WorkerStatusStore {
    static func load() -> WorkerStatus? {
        guard let data = try? Data(contentsOf: AppPaths.statusURL) else {
            return nil
        }
        return try? JSONDecoder().decode(WorkerStatus.self, from: data)
    }
}
