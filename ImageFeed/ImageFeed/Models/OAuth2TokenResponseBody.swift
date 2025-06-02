// MARK: - OAuth2 token response body model
struct OAuth2TokenResponseBody: Decodable {
    let access_token: String
    let token_type: String
    let scope: String
    let created_at: Int
    
    private enum CodingKeys: String, CodingKey {
        case access_token
        case token_type
        case scope
        case created_at
    }
}
