import Foundation

enum Constants {
    static let accessKey = "s6WNUn8B3e_ceX_8_0fzAYeHyFUKw2dHoJ19h1JKipk"
    static let secretKey = "JPMP6CcEMsby3-sDq4D_aqnWUNK7F4XOIZe_386QUmo"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_user+read_photos+write_photos+write_likes+write_followers+read_collections+write_collections"
    static let defaultBaseURLString = "https://unsplash.com/"
    static let apiDefaultBaseURLString = "https://api.unsplash.com/"
    
    static let photoLikeReplacementString = "ID"
    
    enum Service {
        case profileImage
        case profile
        case photos
        case like
        case auth
        
        var urlString: String {
            switch self {
            case .auth:
                defaultBaseURLString + "oauth/authorize"
            case .profileImage:
                apiDefaultBaseURLString + "users/"
            case .profile:
                apiDefaultBaseURLString + "me"
            case .photos:
                apiDefaultBaseURLString + "photos"
            case .like:
                apiDefaultBaseURLString + "photos/\(photoLikeReplacementString)/like"
            }
        }
    }
}
