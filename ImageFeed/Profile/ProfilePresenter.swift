import Foundation
import Kingfisher
import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    //func downloadAvatar(imageView: UIImageView)
    func downloadProfileDetails()
    
    func updateAvatar()
    func downloadAvatar(imageView: UIImageView, url: URL)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    func downloadAvatar(imageView: UIImageView, url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        //let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "userPicPlaceholder"),
                              options: [.processor(processor)])
        
        //view?.updateAvatar()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        //call updateavatar with url
        view?.setAvatar(url: url)
    }
    
    
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
//    func downloadAvatar(imageView: UIImageView) {
//        guard
//            let profileImageURL = profileImageService.avatarURL,
//            let url = URL(string: profileImageURL)
//        else { return }
//        
//        let processor = RoundCornerImageProcessor(cornerRadius: 61)
//        //let imageView = UIImageView()
//        imageView.kf.indicatorType = .activity
//        imageView.kf.setImage(with: url,
//                              placeholder: UIImage(named: "userPicPlaceholder"),
//                              options: [.processor(processor)])
//        
//        view?.updateAvatar()
//    }
    
    func downloadProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(profile: profile)
    }
    
}
