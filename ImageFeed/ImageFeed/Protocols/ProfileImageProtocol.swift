import Foundation

protocol ProfileImageProtocol {
    static var shared: Self { get }
    var avatarURLString: String? { get }
    var task: URLSessionTask? { get }
    func fetchProfileImageURL(
        username: String,
        token: String,
        _ handler: @escaping (Result<String, Error>) -> Void
    )
}
