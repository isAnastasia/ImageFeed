import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date
    let welcomeDescription: String
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(from photo: PhotoResult) {

        let dateFormatter = ISO8601DateFormatter()
        
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)
        self.createdAt = dateFormatter.date(from: photo.createdAt) ?? Date()
        self.welcomeDescription = photo.welcomeDescription
        self.thumbImageURL = photo.urls.thumbImageURL
        self.largeImageURL = photo.urls.largeImageURL
        self.isLiked = photo.isLiked
    }
}

struct UrlsResult: Decodable {
    let thumbImageURL: String
    let largeImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: CGFloat
    let height: CGFloat
    let isLiked: Bool
    let welcomeDescription: String
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case isLiked = "liked_by_user"
        case welcomeDescription = "description"
        case urls
    }
}

final class ImagesListService {
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var lastLoadedPage: Int?
    private var lastTask: URLSessionTask?
    
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        if lastTask != nil {
            return
        }
        
        let nextPage = lastLoadedPage == nil
            ? 1
            : lastLoadedPage! + 1
        
        guard let authToken = oauth2TokenStorage.token else {return}
        
        let request = getPhotosNextPageRequest(page: nextPage, authToken: authToken)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let photosResult):
                    for photoResult in photosResult {
                        let photo = Photo(from: photoResult)
                        self.photos.append(photo)
                    }

                    self.lastLoadedPage = nextPage
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.DidChangeNotification,
                            object: self,
                            userInfo: ["Photos": self.photos])
                    self.lastTask = nil
                case .failure(let error):
                    print(error)
                    self.lastTask = nil
                }
            }
        }
        
        lastTask = task
        task.resume()
        
    }
    
    private func getPhotosNextPageRequest(page: Int, authToken: String) -> URLRequest {
        var perPage: Int = 10
        var request =
        URLRequest.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)"
            + "&&per_page =\(perPage)",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com/")!
        )
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
