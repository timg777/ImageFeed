protocol OAuth2ServiceProtocol {
    func fetchOAuthToken(
        code: String,
        handler: @escaping (Result<String, Error>) -> Void
    )
}
