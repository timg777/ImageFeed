import Foundation

// MARK: - Unsplash user result model
struct UserResult: Codable {
    let profileImage: [String:String]
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
