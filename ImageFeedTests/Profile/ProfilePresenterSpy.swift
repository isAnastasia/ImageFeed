import Foundation
import ImageFeed
import UIKit

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
