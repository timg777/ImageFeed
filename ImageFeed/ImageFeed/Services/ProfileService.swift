import UIKit

final class ProfileService: ProfileServiceProtocol {
    
    enum RequestKind {
        case basicRequest
        case publicRequest
    }
    
    // MARK: - Singletone initialization
    static let shared = ProfileService()
    private init() {}
    
    // MARK: - Private Properties
    private(set) var task: URLSessionTask?
    private(set) var profile: Profile?
}

// MARK: - Extensions + Internal ProfileService -> ProfileServiceProtocol Conformance
extension ProfileService {
    func fetchProfile(
        httpMethod: URLSession.HTTPMethod,
        token: String,
        handler: @escaping (Result<Profile, Error>) -> Void
    ) {
        
        if let _ = task {
            handler(
                .failure(NetworkError.repeatedRequest)
            )
            return
        }

        let urlString =
        Constants
            .Service
            .profile
            .urlString
        let headers: [String:String] = ["Authorization": "Bearer \(token)"]
        
        do {
            task = try URLSession.shared.objectTask(
                urlString: urlString,
                headerFields: headers
            ) { [weak self] (result: Result<ProfileResult, Error>) in
                guard let self else { return }
                
                switch result {
                case .success(let value):
                    let username = value.username ?? "No data"
                    let name = "\(value.first_name ?? "No data") \(value.last_name ?? "No data")"
                    let loginName = "@\(value.username ?? "No data")"
                    let bio = value.bio ?? "No Data"
                    
                    let profile = Profile(
                        username: username,
                        name: name,
                        loginName: loginName,
                        bio: bio
                    )
                    self.profile = profile
                    handler(
                        .success(profile)
                    )
                    
                    NotificationCenter.default
                        .post(
                            name: .profileServiceProviderDidChangeNotification,
                            object: self,
                            userInfo: [UserInfoKey.userProfile.rawValue: profile]
                        )
                    
                    task?.cancel()
                    task = nil
                case .failure(let error):
                    handler(
                        .failure(error)
                    )
                    task?.cancel()
                    task = nil
                }
            }
            
            task?.resume()
        } catch {
            handler(
                .failure(error)
            )
            task?.cancel()
            task = nil
        }
    }
}
