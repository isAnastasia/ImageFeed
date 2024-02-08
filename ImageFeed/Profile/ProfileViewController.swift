import UIKit
import WebKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? {get set}
    func updateProfileDetails(profile: Profile)
    //func updateAvatar()
    
    func setAvatar(url: URL)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    func setAvatar(url: URL) {
        presenter?.downloadAvatar(imageView: avatarImageView, url: url)
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = false
        avatarImageView.clipsToBounds = true
    }
    
//    func updateAvatar() {
//        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
//        avatarImageView.layer.masksToBounds = false
//        avatarImageView.clipsToBounds = true
//    }
    
    func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    var presenter: ProfilePresenterProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    //private var imageView: UIImageView!
    private var avatarImageView: UIImageView = UIImageView()
    private var nameLabel: UILabel!
    private var loginLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logOutButton: UIButton!
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setImageView()
        setNameLabel()
        setLoginLabel()
        setDescriptionLabel()
        setLogOutButton()
        
        //!!!!!!!!!!!!!!!!!!!
        //updateProfileDetails(profile: profileService.profile)
        presenter?.downloadProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                //self.updateAvatar()
                
                //self.presenter?.downloadAvatar(imageView: self.avatarImageView)
                self.presenter?.updateAvatar()
            }
        //updateAvatar()
        //presenter?.downloadAvatar(imageView: avatarImageView)
        presenter?.updateAvatar()
        
    }
    
    // 1 ответственность - подгрузка фото из сети
//    func updateAvatar() {
//        guard
//            let profileImageURL = ProfileImageService.shared.avatarURL,
//            let url = URL(string: profileImageURL)
//        else { return }
//
//        let processor = RoundCornerImageProcessor(cornerRadius: 61)
//        imageView.kf.indicatorType = .activity
//        imageView.kf.setImage(with: url,
//                              placeholder: UIImage(named: "userPicPlaceholder"),
//                              options: [.processor(processor)])
//        // это оставляем здесь
//        imageView.layer.cornerRadius = imageView.frame.height / 2
//        imageView.layer.masksToBounds = false
//        imageView.clipsToBounds = true
//    }
    
    // 2 ответственность - получение профиля из ПрофильСервис
//    private func updateProfileDetails(profile: Profile?) {
//        // перенести
//        guard let profile = profile else { return }
//        // оставляем здесь
//        nameLabel.text = profile.name
//        loginLabel.text = profile.loginName
//        descriptionLabel.text = profile.bio
//    }
    
    
    private func setImageView() {
        let image = UIImage(named: "Avatar")
        avatarImageView = UIImageView(image: image)
        //imageView.image = image
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func setNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textColor = UIColor.white
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
    }
    
    private func setLoginLabel() {
        loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginLabel.textColor = UIColor(named: "YP Gray") ?? UIColor.gray
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        NSLayoutConstraint.activate([
            loginLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
        
    }
    private func setDescriptionLabel() {
        descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor.white
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setLogOutButton() {
        let buttonImage = UIImage(named: "Exit")
        logOutButton = UIButton.systemButton(
            with: buttonImage!,
            target: self,
            action: #selector(didTapLogoutButton)
        )
        logOutButton.tintColor = UIColor(named: "YP Red") ?? UIColor.red
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            logOutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])        
    }
    
    private func showConfirmationAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let self = self else {return}
//            self.clean()
//            OAuth2TokenStorage.removeAuthToken()
            Cleaner.clean()
            
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // 3 ответсвенность - очистка
//    private func clean() {
//       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
//          records.forEach { record in
//             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
//          }
//       }
//    }
    
    @objc func didTapLogoutButton() {
        showConfirmationAlert()
    }
}
