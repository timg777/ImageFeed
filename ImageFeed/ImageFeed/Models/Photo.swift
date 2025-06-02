import Foundation

// MARK: - Converted unsplash photo model
struct Photo: Hashable {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURLString: String
    let largeImageURLString: String
    private(set) var isLiked: Bool
    
    mutating func toggleLike() {
        isLiked.toggle()
    }
}
