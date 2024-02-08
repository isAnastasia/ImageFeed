import Foundation
import Kingfisher
import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func downloadProfileDetails()
    
    func updateAvatar()
    func downloadAvatar(imageView: UIImageView, url: URL)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    func downloadAvatar(imageView: UIImageView, url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 61)

        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "userPicPlaceholder"),
                              options: [.processor(processor)])
    }
    
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
