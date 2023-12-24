import UIKit

class ProfileViewController: UIViewController {
    
    private var imageView: UIImageView!
    private var nameLabel: UILabel!
    private var loginLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageView()
        setNameLabel()
        setLoginLabel()
        setDescriptionLabel()
        setLogOutButton()
        
    }
    
    private func setImageView() {
        let image = UIImage(named: "Avatar")
        imageView = UIImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func setNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textColor = UIColor.white
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
    }
    
    private func setLoginLabel() {
        loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginLabel.textColor = UIColor(named: "YP Gray") ?? UIColor.gray
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        loginLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    private func setDescriptionLabel() {
        descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor.white
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
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
        
        logOutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc func didTapLogoutButton() {
        print("button pressed")
    }
}
