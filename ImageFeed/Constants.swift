import Foundation

enum ApiConstants {
    static let unsplashAuthorizeURLString: String = "https://unsplash.com/oauth/authorize"
    static let accessKey = "RltSXlVTp5nAOy71aHFE1qCOpjBFdehtvwDIlV8MuZI"
    static let secretKey = "F0UzhNXVOGoNKIG6MOBnVUtXCJspg9Ov8a2yVwKR-UY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}
