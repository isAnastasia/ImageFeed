@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    
    func testViewDidLoadCallsFetchPhotos() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.fetchPhotosWasCalled)
    }
    
    func testNewPhotosUploadedAfterFetchPhotosWasCalled() {
        //given
        let viewController = ImagesListViewController()
        
        let presenter = ImagesListPresenterMock()
        let imageService = ImagesListServiceSpy.shared
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.presenter?.fetchPhotos()
        
        //then
        XCTAssertTrue(imageService.photosWereUpdated)
    }
}
