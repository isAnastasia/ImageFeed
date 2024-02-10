import Foundation
import Kingfisher

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func downloadProfileDetails()
    
    func updateAvatar()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.setAvatar(url: url)
    }
    
    func downloadProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(profile: profile)
    }
}
