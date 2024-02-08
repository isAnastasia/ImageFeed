@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    
    func testImagesListViewControllerCallsFetchPhotosAfterViewDidLoad() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.fetchPhotos()
        
        //then
        XCTAssertTrue(viewController.updateTableViewAnimatedWasCalled)
    }
    
    func testImagesListViewControllerCallsFetchPhotos() {
        
    }

}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var updateTableViewAnimatedWasCalled: Bool = false
    func updateTableViewAnimated() {
        updateTableViewAnimatedWasCalled = true
    }
    
    var presenter: ImagesListPresenterProtocol?
    
    
    
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var fetchPhotosWasCalled: Bool = false
    
    func fetchPhotos() {
        fetchPhotosWasCalled = true
        view?.updateTableViewAnimated()
    }
    
    
}
