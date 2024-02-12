import Foundation
import ImageFeed
import UIKit

final class ProfileViewControllerMock: ProfileViewControllerProtocol {
    var avatarImageView: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var loginLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    var logOutButton: UIButton = UIButton()
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    
    func updateProfileDetails(profile: Profile) {
        
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func setAvatar(url: URL) {
        
    }
}
