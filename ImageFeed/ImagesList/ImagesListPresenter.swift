import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func fetchPhotos()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
}
