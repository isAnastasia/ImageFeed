import Foundation

public struct Profile {
    public let username: String
    public let name: String
    public let loginName: String
    public let bio: String
    
    public init(username: String, firstName: String, lastName: String, bio: String) {
        self.username = username
        self.name = firstName + " " + lastName
        self.loginName = "@" + username
        self.bio = bio
    }
}
