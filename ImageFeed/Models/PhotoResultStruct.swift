import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: CGFloat
    let height: CGFloat
    let isLiked: Bool
    let welcomeDescription: String?
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

struct UpdatedPfotoResult: Decodable {
    let photo: PhotoResult?
}
