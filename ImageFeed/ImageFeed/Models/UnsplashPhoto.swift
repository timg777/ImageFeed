struct UnsplashPhoto: Decodable {
    let id: String
    let created_at: String?
    let width: Int
    let height: Int
    let description: String?
    let liked_by_user: Bool
    let urls: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case id, created_at, width, height, description, liked_by_user, urls
    }
    
    enum UnsplashPhotoURLsKind: String {
        case raw, full, regular, small, thumb
    }
}
