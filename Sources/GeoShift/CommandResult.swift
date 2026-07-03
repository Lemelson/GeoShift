struct CommandResult: Sendable {
    let status: Int32
    let output: String

    var succeeded: Bool {
        status == 0
    }
}
