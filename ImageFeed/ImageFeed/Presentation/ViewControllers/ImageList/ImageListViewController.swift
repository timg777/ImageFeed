import UIKit

final class ImageListViewController: UIViewController {

    // MARK: - Private Views
    private lazy var tableView: UITableView = {
        .init()
    }()
    
    // MARK: - Private Contants
    private let imagesListService: ImagesListServiceProtocol = ImagesListService.shared
    
    private lazy var observerObject: Observer? = {
        try? Observer(
            self,
            from: [
                ImagesListService.self
            ],
            for: [
                .imagesListServicePhotosDidChangeNotification
            ]
        )
    }()
    
    // MARK: - Private Properties
    private var photos = [Photo]()
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Internal Properties
    var token: String? {
        SecureStorage.shared.getToken()
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        if let observerObject {
            NotificationCenterManager.shared.addObserver(observerObject)
        } else {
            logErrorToSTDIO(
                errorDescription: "Failed to create observer object for notifications"
            )
        }
        
        alertPresenter = AlertPresenter()
        
        UIBlockingActivityIndicator.showActivityIndicator()
        imagesListService.fetchPhotosNextPage { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                break
            case .failure:
                alertPresenter?.present(present: present)
            }
            UIBlockingActivityIndicator.dismissActivityIndicator()
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        setUpViews()
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
    }
    
    deinit {
        NotificationCenterManager.shared.removeObserver(observerObject)
    }
}

// MARK: - Extensions + Internal ImageListViewController -> NotificationObserver Conformance
extension ImageListViewController: NotificationObserver {
    func handleNotification(_ notification: Notification) {
        if notification.name == .imagesListServicePhotosDidChangeNotification {
            updateTableViewAnimated()
        }
    }
}

// MARK: - Extensions + Internal ImageListViewController -> ImageListCellDelegate Conformance
extension ImageListViewController: ImagesListCellDelegate {
    func didTapLike(_ cell: ImagesListCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let token = token
        else { return }
        
        UIBlockingActivityIndicator.showActivityIndicator()
        imagesListService.changeLike(
            token: token,
            photoIndex: indexPath.row
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                photos = imagesListService.photos
                cell.setIsLiked(photos[indexPath.row].isLiked)
            case .failure:
                alertPresenter?.present(present: present)
            }
            UIBlockingActivityIndicator.dismissActivityIndicator()
        }
    }
}

// MARK: - Extensions + Private ImageListViewController Routing
private extension ImageListViewController {
    func routeToSingleImage(with indexPath: IndexPath) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        let singleImageViewController = SingleImageViewController()
        let photo = imagesListService.photos[safe: indexPath.row]
        singleImageViewController.imageURLString = photo?.largeImageURLString
        singleImageViewController.imageSize = photo?.size
        
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(
            singleImageViewController,
            animated: true
        )
    }
}

// MARK: - Extensions + Internal ImageListViewController -> UITableViewDelegate Conformance
extension ImageListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        routeToSingleImage(with: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let imageSize = imagesListService.photos[safe: indexPath.row]?.size ?? .zero
        
        let imageInsets = GlobalNamespace.imageInsets
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / (imageWidth == 0 ? 1 : imageWidth)
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == photos.count - 1 {
            UIBlockingActivityIndicator.showActivityIndicator()
            imagesListService.fetchPhotosNextPage { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    break
                case .failure:
                    alertPresenter?.present(present: present)
                }
                UIBlockingActivityIndicator.dismissActivityIndicator()
            }
        }
    }
}

// MARK: - Extensions + Intrnal ImageListViewController -> UITableViewDataSource Conformance
extension ImageListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        photos.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let reuseIdentifier = ImagesListCell.reuseIdentifier
        
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: reuseIdentifier,
                for: indexPath
            ) as? ImagesListCell
        else {
            logErrorToSTDIO(
                errorDescription: "Cant dequeue cell with reuseIdentifier: \(reuseIdentifier)"
            )
            return UITableViewCell()
        }

        let photo = photos[safe: indexPath.row]
        cell.configureListCell(photo: photo)
        cell.delegate = self
        return cell
    }
}

// MARK: - Extensions + Private ImageListViewController View Updates
private extension ImageListViewController {

    func updateTableViewAnimated() {
        let oldPhotoCount = photos.count
        let newPhotoCount = imagesListService.photos.count
        photos = imagesListService.photos

        tableView.beginUpdates()
        
        if oldPhotoCount < newPhotoCount {
            let indexPaths = (oldPhotoCount..<newPhotoCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } else if oldPhotoCount > newPhotoCount {
            let indexPaths = (newPhotoCount..<oldPhotoCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
        
        tableView.endUpdates()
    }

}

// MARK: - Extensions + Private ImageListViewController Setting Up Views
private extension ImageListViewController {
    func setUpViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .ypBlack
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(
                equalToConstant: view.bounds.width
            ),
            tableView.heightAnchor.constraint(
                equalToConstant: view.bounds.height
            ),
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
}
