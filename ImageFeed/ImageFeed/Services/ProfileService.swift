import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    private init() {}
    
    enum RequestKind {
        case basicRequest
        case publicRequest
    }
    
    private(set) var profile: Profile?
    
    func fetchProfile(
        httpMethod: URLSession.HTTPMethod,
        token: String,
        handler: @escaping (Result<Profile, Error>) -> Void
    ) {

        let urlString = "https://api.unsplash.com/me"
        let headers: [String:String] = ["Authorization": "Bearer \(token)"]
        
        do {
            let task = try URLSession.shared.objectTask(
                urlString: urlString,
                headerFields: headers
            ) { [weak self] (result: Result<ProfileResult, Error>) in
                guard let _ = self else { return }
                switch result {
                case .success(let value):
                    let profile = Profile(
                        username: value.username ?? "No data",
                        name: "\(value.first_name ?? "No data") \(value.last_name ?? "No data")",
                        loginName: "@\(value.username ?? "No data")",
                        bio: value.bio ?? "No Data"
                    )
                    self?.profile = profile
                    handler(.success(profile))
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
