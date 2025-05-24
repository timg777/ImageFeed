import UIKit

final class ProfileImageService: ProfileImageProvider {
    
    enum ImageSizeStrategy: String {
        case small
        case medium
        case large
    }
    
    static let shared = ProfileImageService()
    private init() {}
    
    let profileImagedidChangeNotification = Notification.Name(rawValue: GlobalNamespace.NorificationName.profileImageProviderDidChange.rawValue)
    
    private(set) var avatarURLString: String?
    private(set) var task: URLSessionTask?
    
    func fetchProfileImageURL(
        username: String,
        token: String,
        _ handler: @escaping (Result<String, Error>) -> Void
    ) {
        
        if let _ = task {
            handler(.failure(NetworkError.repeatedRequest))
            return
        }
        
        let urlString = Constants.Service.profileImage.urlString + username
        let headers: [String:String] = ["Authorization": "Bearer \(token)"]
        let imageSizeStrategy: ImageSizeStrategy = .large
        
        do {
            task = try URLSession.shared.objectTask(
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
                            name: ProfileImageService.shared.profileImagedidChangeNotification,
                            object: self,
                            userInfo: [UserInfoKey.profileImageURLString.rawValue: avatarURLString]
                        )
                    
                    task?.cancel()
                    task = nil

                case .failure(let error):
                    handler(.failure(error))
                    task?.cancel()
                    task = nil
                }
            }
            
            task?.resume()
        } catch {
            handler(.failure(error))
            task?.cancel()
            task = nil
        }
    }
}
