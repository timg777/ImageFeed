import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let authURLString: String

    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURL: URL?
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        .init(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: Constants.Service.auth.urlString,
            defaultBaseURL: URL(string: Constants.defaultBaseURLString)
        )
    }
    
    static var test: AuthConfiguration {
        .init(
            accessKey: "",
            secretKey: "",
            redirectURI: "",
            accessScope: "",
            authURLString: "",
            defaultBaseURL: nil
        )
    }
}
