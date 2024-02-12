import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var fetchPhotosWasCalled: Bool = false
    
    func fetchPhotos() {
        fetchPhotosWasCalled = true
    }
}
