import Foundation

struct UserResult: Codable {
    let profileImage: [String:String]
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
