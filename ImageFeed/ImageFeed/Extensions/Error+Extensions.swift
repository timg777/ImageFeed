// MARK: - Extensions + Internal Helpers
extension Error {
    /// error description using TracedError Protocol
    var tracedDescription: String {
        (self as? TracedError)?.description ?? localizedDescription
    }
}
