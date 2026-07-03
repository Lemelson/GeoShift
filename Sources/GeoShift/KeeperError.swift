import Foundation

enum KeeperError: LocalizedError {
    case commandFailed(String)
    case missingDependency(String)
    case missingKeeper

    var errorDescription: String? {
        switch self {
        case .commandFailed(let output):
            output.isEmpty ? "Команда завершилась с ошибкой." : output
        case .missingDependency(let path):
            "Не найден pymobiledevice3: \(path)"
        case .missingKeeper:
            "В приложении отсутствует keeper.py."
        }
    }
}
