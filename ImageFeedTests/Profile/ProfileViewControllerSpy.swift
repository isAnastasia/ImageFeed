import Foundation
import ImageFeed

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
