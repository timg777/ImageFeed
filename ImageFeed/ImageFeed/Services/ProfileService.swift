import UIKit

final class ProfileService: ProfileServiceProtocol {
    
    static let shared = ProfileService()
    private init() {}
    
    enum RequestKind {
        case basicRequest
        case publicRequest
    }
    
    private(set) var task: URLSessionTask?
    
    private(set) var profile: Profile?
    
    func fetchProfile(
        httpMethod: URLSession.HTTPMethod,
        token: String,
        handler: @escaping (Result<Profile, Error>) -> Void
    ) {
        
        if let _ = task {
            handler(.failure(NetworkError.repeatedRequest))
            return
        }

        let urlString = Constants.Service.profile.urlString
        let headers: [String:String] = ["Authorization": "Bearer \(token)"]
        
        do {
            task = try URLSession.shared.objectTask(
                urlString: urlString,
                headerFields: headers
            ) { [weak self] (result: Result<ProfileResult, Error>) in
                guard let self else { return }
                
                switch result {
                case .success(let value):
                    let profile = Profile(
                        username: value.username ?? "No data",
                        name: "\(value.first_name ?? "No data") \(value.last_name ?? "No data")",
                        loginName: "@\(value.username ?? "No data")",
                        bio: value.bio ?? "No Data"
                    )
                    self.profile = profile
                    handler(.success(profile))
                    
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
