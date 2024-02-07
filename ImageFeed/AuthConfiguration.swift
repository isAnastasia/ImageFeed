import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = ApiConstants.accessKey
        self.secretKey = ApiConstants.secretKey
        self.redirectURI = ApiConstants.redirectURI
        self.accessScope = ApiConstants.accessScope
        self.defaultBaseURL = ApiConstants.defaultBaseURL
        self.authURLString = ApiConstants.unsplashAuthorizeURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: ApiConstants.accessKey,
                                 secretKey: ApiConstants.secretKey,
                                 redirectURI: ApiConstants.redirectURI,
                                 accessScope: ApiConstants.accessScope,
                                 authURLString: ApiConstants.unsplashAuthorizeURLString,
                                 defaultBaseURL: ApiConstants.defaultBaseURL)
    }
}
