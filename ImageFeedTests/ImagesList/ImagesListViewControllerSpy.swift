import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    var updateTableViewAnimatedWasCalled: Bool = false
    
    func viewDidLoad() {
        presenter?.fetchPhotos()
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedWasCalled = true
    }
}
