import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(id: String,
        size: CGSize,
        createdAt: Date?,
        welcomeDescription: String,
        thumbImageURL: String,
        largeImageURL: String,
        isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }

    init(from photo: PhotoResult) {
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)
        self.createdAt = DateFormatters.iSO8601dateFormatter.date(from: photo.createdAt)
        self.welcomeDescription = photo.welcomeDescription ?? ""
        self.thumbImageURL = photo.urls.thumbImageURL
        self.largeImageURL = photo.urls.largeImageURL
        self.isLiked = photo.isLiked
    }
}
