import ImageFeed
import Foundation

final class ImagesListPresenterMock: ImagesListPresenterProtocol {
    private let imagesListService = ImagesListServiceSpy.shared
    
    var view: ImagesListViewControllerProtocol?
    
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
}
