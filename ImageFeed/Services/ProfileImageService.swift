import Foundation

final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    private (set) var avatarURL: String?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        guard let authToken = oauth2TokenStorage.token else {return}
        
        let request = getImageInfoRequest(username: username, authToken: authToken)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let smallImageUrl = body.profileImage.small
                self.avatarURL = smallImageUrl
                completion(.success(smallImageUrl))
            
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": smallImageUrl])
            case .failure(let error):
                completion(.failure(error))
            }
        }        
        task.resume()
    }
    
    private func getImageInfoRequest( username: String, authToken: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com/")!
        )
        
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization" )
        return request
    }
}
