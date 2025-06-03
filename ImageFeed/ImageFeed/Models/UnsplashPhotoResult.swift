import Foundation

// MARK: - Unsplash photo result model
struct UnsplashPhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case id, width, height, description, urls
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
    }
    
    enum UnsplashPhotoURLsKind: String {
        case raw, full, regular, small, thumb
    }
}
