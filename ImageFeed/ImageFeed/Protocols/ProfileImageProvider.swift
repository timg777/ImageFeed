import Foundation

protocol ProfileImageProvider {
    var profileImagedidChangeNotification: Notification.Name { get }
    var avatarURLString: String? { get }
    var task: URLSessionTask? { get }
    func fetchProfileImageURL(
        username: String,
        token: String,
        _ handler: @escaping (Result<String, Error>) -> Void
    )
}
