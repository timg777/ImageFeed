protocol OAuth2ServiceProtocol {
    func fetchOAuthToken(code: String, _ handler: @escaping (Result<String, Error>) -> Void)
}
