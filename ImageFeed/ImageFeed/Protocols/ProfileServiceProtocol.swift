import Foundation

protocol ProfileServiceProtocol {
    static var shared: Self { get }
    var profile: Profile? { get }
    var task: URLSessionTask? { get }
    func fetchProfile(
        httpMethod: URLSession.HTTPMethod,
        token: String,
        handler: @escaping (Result<Profile, Error>) -> Void
    )
}
