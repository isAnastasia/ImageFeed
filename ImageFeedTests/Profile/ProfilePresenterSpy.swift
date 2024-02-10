import Foundation
import ImageFeed

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
    
}
