@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testProfileDetailsUpdatesLabels() {
        // given
        let view = ProfileViewControllerMock()
        let profile = Profile(username: "@username", firstName: "Bob", lastName: "Smith", bio: "bio")
        
        //when
        view.updateProfileDetails(profile: profile)
        
        // then
        XCTAssertEqual(view.nameLabel.text, profile.name)
    }
    
    func testViewDidLoadCallsUpdateProfileDetails() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
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
        
        //when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.updateAvatarWasCalled)
    }
    
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
    
    func testProfileViewControllerSetsAvatar() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        let url = ApiConstants.defaultBaseURL
        
        //when
        presenter.view?.setAvatar(url: url)
        
        //Then
        XCTAssertTrue(viewController.setAvatarWasCalled)
    }
}
