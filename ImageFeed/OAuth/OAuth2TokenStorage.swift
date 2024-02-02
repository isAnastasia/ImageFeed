import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private enum Keys: String {
        case token
    }
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "Auth token")
        }
        set {
            KeychainWrapper.standard.set(newValue ?? "", forKey: "Auth token")
        }
    }
    
    static func removeAuthToken(){
        KeychainWrapper.standard.removeObject(forKey: "Auth token")
    }
}
