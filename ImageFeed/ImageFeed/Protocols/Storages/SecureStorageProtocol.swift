protocol SecureStorageProtocol {
    func getToken() -> String?
    func setToken(_ token: String)
    func removeToken()
}
