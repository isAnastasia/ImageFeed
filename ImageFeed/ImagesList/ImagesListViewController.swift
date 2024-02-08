import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    var photos: [Photo] = []

    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter = ImagesListPresenter(view: self)
        
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        
        presenter?.fetchPhotos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let fullImageUrl = URL(string: photos[indexPath.row].largeImageURL)
            viewController.fullImageURL = fullImageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func showLikeErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось поставить лайк", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Table View Delegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageWidth = image.size.width
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let coef = imageViewWidth / imageWidth
        
        let imageViewHeight = image.size.height * coef + imageInsets.top + imageInsets.bottom
        return imageViewHeight
    }
}


//MARK: - Table View Data Source
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
            
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
            
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        addGradient(to: imageListCell.cellImage, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let imageUrlPath = photos[indexPath.row].thumbImageURL
        let imageUrl = URL(string: imageUrlPath)
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loader.png"))
        {
            [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
        
        let likeImage = imagesListService.photos[indexPath.row].isLiked ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff")
        
        if let date = photos[indexPath.row].createdAt {
            cell.dateLabel.text = DateFormatters.dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    private func addGradient(to imageView: UIImageView, with indexPath: IndexPath) {
        let viewHeight = tableView(tableView, heightForRowAt: indexPath)
        
        if let sublayers = imageView.layer.sublayers {
            for layer in sublayers {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                    break
                }
            }
        }
        
        let gradientStartColor = UIColor.ypBlack.withAlphaComponent(0.20).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: viewHeight - 30, width: imageView.bounds.width, height: 30)
        gradientLayer.colors = [UIColor.clear.cgColor, gradientStartColor]
        gradientLayer.locations = [0.0, 1.0]

        imageView.layer.addSublayer(gradientLayer)
    }
    
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        // подгрузка фото
        if indexPath.row + 1 == imagesListService.photos.count {
            //imagesListService.fetchPhotosNextPage()
            presenter?.fetchPhotos()
        }
    }
}

// 2 ответственность - нажал лайк - связь с сервером
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showLikeErrorAlert()
                }
            }
        }
    }
    
}
