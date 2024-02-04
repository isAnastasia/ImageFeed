import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    
    func fetchProfile(
        _ authToken: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        let request = getBaseInfoRequest(authToken: authToken)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return}
            switch result {
            case .success(let body):
                let profile = Profile(
                    username: body.username,
                    firstName: body.firstName,
                    lastName: body.lastName,
                    bio: body.bio ?? "")
                self.profile = profile
                completion(.success(profile))
            case .failure(let err):
                completion(.failure(err))
            }
        }
        task.resume()
    }
    
    private func getBaseInfoRequest(authToken: String) -> URLRequest {
        var request =
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com/")!
        )
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
