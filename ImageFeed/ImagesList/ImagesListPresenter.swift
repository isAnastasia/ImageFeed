import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func fetchPhotos()
    
    //func changeLike(indexPath: IndexPath, photo: Photo)
}
final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    private let imagesListService = ImagesListService.shared
}
