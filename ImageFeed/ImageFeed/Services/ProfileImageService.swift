import UIKit

final class ProfileImageService {
    
    enum ImageSizeStrategy: String {
        case small
        case medium
        case large
    }
    
    static let shared = ProfileImageService()
    private init() {}
    
    let didChangeNotification = Notification.Name(rawValue: GlobalNamespace.NorificationName.profileImageProviderDidChange.rawValue)
    
    private(set) var avatarURLString: String?
    
    func fetchProfileImageURL(username: String, token: String, _ handler: @escaping (Result<String, Error>) -> Void) {
        let urlString = Constants.Service.profileImage.urlString + username
        let headers: [String:String] = ["Authorization": "Bearer \(token)"]
        let imageSizeStrategy: ImageSizeStrategy = .large
        
        do {
            let task = try URLSession.shared.objectTask(
                urlString: urlString,
                headerFields: headers
            ) { [weak self] (result: Result<UserResult, Error>) in
                guard let self else { return }
                switch result {
                case .success(let userResult):
                    guard
                        let avatarURLString = userResult.profileImage[imageSizeStrategy.rawValue]
                    else {
                        handler(.failure(ParseError.decodeError(T: UserResult.self)))
                        return
                    }
                    self.avatarURLString = avatarURLString
                    handler(.success(avatarURLString))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.shared.didChangeNotification,
                            object: self,
                            userInfo: [UserInfoKey.profileImageURLString.rawValue: avatarURLString]
                        )

                case .failure(let error):
                    handler(.failure(error))
                }
            }
            
            task.resume()
        } catch {
            handler(.failure(error))
        }
    }
}
