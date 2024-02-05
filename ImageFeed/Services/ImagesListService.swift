import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var lastLoadedPage: Int?
    private var lastTask: URLSessionTask?
    
    private init() { }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = oauth2TokenStorage.token else {return}
        
        let request: URLRequest = isLike ? getLikeRequest(photoId: photoId, authToken: token) : getDislikeRequest(photoId: photoId, authToken: token)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UpdatedPfotoResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let photoResult):
                    DispatchQueue.main.async {
                        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                            let photo = self.photos[index]
                            let newPhoto = Photo(
                                id: photo.id,
                                size: photo.size,
                                createdAt: photo.createdAt ?? nil,
                                welcomeDescription: photo.welcomeDescription,
                                thumbImageURL: photo.thumbImageURL,
                                largeImageURL: photo.largeImageURL,
                                isLiked: !photo.isLiked
                            )
                            self.photos[index] = newPhoto
                        }
                    }
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
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
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["Photos": self.photos])
                    self.lastTask = nil
                case .failure(let error):
                    self.lastTask = nil
                }
            }
        }
        lastTask = task
        task.resume()
    }
    
    private func getLikeRequest(photoId: String, authToken: String) -> URLRequest {
        var request =
        URLRequest.makeHTTPRequest(
            path: "/photos/"
            + "\(photoId)/like",
            httpMethod: "POST",
            baseURL: URL(string: "https://api.unsplash.com/")!
        )
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func getDislikeRequest(photoId: String, authToken: String) -> URLRequest {
        var request =
        URLRequest.makeHTTPRequest(
            path: "/photos/"
            + "\(photoId)/like",
            httpMethod: "DELETE",
            baseURL: URL(string: "https://api.unsplash.com/")!
        )
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func getPhotosNextPageRequest(page: Int, authToken: String) -> URLRequest {
        let perPage: Int = 10
        var request =
        URLRequest.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)"
            + "&&per_page=\(perPage)",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com/")!
        )
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
