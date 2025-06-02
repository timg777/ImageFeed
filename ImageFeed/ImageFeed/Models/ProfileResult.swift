// MARK: - Unsplaash user profile result model
struct ProfileResult: Codable {
    let username: String?
    let first_name: String?
    let last_name: String?
    let email: String?
    let url: String?
    let location: String?
    let bio: String?
    let instagram_username: String?
    
    private enum CodingKeys: String, CodingKey {
        case username
        case first_name
        case last_name
        case email
        case url
        case location
        case bio
        case instagram_username
    }
}
