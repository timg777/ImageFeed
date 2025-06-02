import CoreGraphics

// MARK: - Unsplash photo result model
struct UnsplashPhotoResult: Decodable {
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
    
    func convert() -> Photo {
        
        let thumbPhotoSizeStrategy: UnsplashPhotoResult.UnsplashPhotoURLsKind = .thumb
        let largePhotoSizeStrategy: UnsplashPhotoResult.UnsplashPhotoURLsKind = .full
        
        let size = CGSize(
            width: width,
            height: height
        )
        let createAt = created_at?.correctDateFormat
        let thumbImageURLString = urls[
            thumbPhotoSizeStrategy.rawValue,
            default: ""
        ]
        let largeImageURLString = urls[
            largePhotoSizeStrategy.rawValue,
            default: ""
        ]
        
        return .init(
            id: id,
            size: size,
            createdAt: createAt,
            welcomeDescription: description,
            thumbImageURLString: thumbImageURLString,
            largeImageURLString: largeImageURLString,
            isLiked: liked_by_user
        )
    }
}
