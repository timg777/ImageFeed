import UIKit

final class ImageListViewController: UIViewController {

    // MARK: - Private Views
    private lazy var tableView: UITableView = {
        .init()
    }()
    
    // MARK: - Private Contants
    private let imagesListService: ImagesListServiceProtocol = ImagesListService()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        imagesListService.fetchPhotosNextPage()
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        
        NotificationCenter.default.addObserver(
            forName: ImagesListService.imagesListServiceDidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.setUpViews()
            }
    }
}

// MARK: - Extensions + Private Routing
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
        navigationController?.pushViewController(
            singleImageViewController,
            animated: true
        )
    }
}

// MARK: - Extensions + Internal UITableViewDelegate Conformance
extension ImageListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        routeToSingleImage(with: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let lastLoadedPage = imagesListService.lastLoadedPage ?? 0
        let photoIndex = (lastLoadedPage * GlobalNamespace.imagesListServicePhotosPerPageCount) + lastLoadedPage
        let imageSize = imagesListService.photos[safe: photoIndex]?.size ?? .zero
        
        let imageInsets = GlobalNamespace.imageInsets
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / (imageWidth == 0 ? 1 : imageWidth)
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
//        return 252
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        tableView.reloadRows(at: [indexPath], with: .middle)
//        imagesListService.fetchPhotosNextPage()
        #warning("TODO: <#comment#>")

    }
}

// MARK: - Extensions + Intrnal UITableViewDataSource Conformance
extension ImageListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        imagesListService.photos.count
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

        
        let lastLoadedPage = imagesListService.lastLoadedPage ?? 0
        let photo = imagesListService.photos[safe: indexPath.row]
        let fullPhotoURLString = photo?.largeImageURLString ?? ""
        let dateString = photo?.createdAt?.convertToString() ?? "<No date>"
        let imageLiked = photo?.isLiked ?? false
        cell.configureListCell(with: fullPhotoURLString, dateString: dateString, imageLiked: imageLiked)
        return cell
    }
}

// MARK: - Extensions + Private Setting Up Views
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
