@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    // проверить что когда вью дид лоад у контроллера то две функции вызывается у презентера

    // профиль вью контроллер вызывает downloadProfileDetails у презентара
//    func testProfileViewControllerUpdatesProfileDetails() {
//        // given
//        let viewController = ProfileViewController()
//        let presenter = ProfilePresenterSpy()
//        viewController.presenter = presenter
//        presenter.view = viewController
//
//
//        // when
//        viewController.presenter?.downloadProfileDetails()
//
//        // then
//        XCTAssertTrue(presenter.downloadProfileDetailsWasCalled)
//    }
    
    func testViewDidLoadCallsUpdateProfileDetails() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.downloadProfileDetailsWasCalled)
    }
    
    func testViewDidLoadCallsUpdateAvatar() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.updateAvatarWasCalled)
    }
    
    // профиль вью контроллер обновляет данные на странице профиля после вызова downloadProfileDetails у презентара
    func testProfileViewControllerUpdatesProfileDEtails() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        let profile = Profile(username: "", firstName: "", lastName: "", bio: "")
        //when
        presenter.view?.updateProfileDetails(profile: profile)
        
        //then
        XCTAssertTrue(viewController.updateProfileDetailsWasCalled)
    }
    
    // профиль вью контроллер устанавливает автар после вызова downloadAvatar у презентара
    func testProfileViewControllerSetsAvatar() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        let imageView = UIImageView()
        let url = ApiConstants.defaultBaseURL
        
        //when
        presenter.view?.setAvatar(url: url)
        
        //Then
        XCTAssertTrue(viewController.setAvatarWasCalled)
    }

}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var downloadProfileDetailsWasCalled: Bool = false
    var updateAvatarWasCalled: Bool = false
    
    func downloadProfileDetails() {
        downloadProfileDetailsWasCalled = true
    }
    
    func updateAvatar() {
        updateAvatarWasCalled = true
    }
    
    func downloadAvatar(imageView: UIImageView, url: URL) {
        
    }
    

}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var updateProfileDetailsWasCalled: Bool = false
    var setAvatarWasCalled: Bool = false
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        updateProfileDetailsWasCalled = true
    }
    
    func setAvatar(url: URL) {
        setAvatarWasCalled = true
    }


}
