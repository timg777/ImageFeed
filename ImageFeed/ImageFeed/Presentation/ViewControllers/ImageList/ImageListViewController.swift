import UIKit

final class ImageListViewController: UIViewController & ImageListViewControllerProtocol {

    // MARK: - Private Views
    private lazy var tableView: UITableView = {
        .init()
    }()
    
    // MARK: - Internal Properties
    var presenter: ImageListPresenterProtocol?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        
        setUpViews()
    }
}

// MARK: - Extensions + Internal ImageListViewController -> ImageListViewControllerProtocol Conformance
extension ImageListViewController {
    func lockUI() {
        UIBlockingActivityIndicator.showActivityIndicator()
    }
    
    func unlockUI() {
        UIBlockingActivityIndicator.dismissActivityIndicator()
    }
    
    func updateTableViewIfNeeded(photoCountsAtDifferentTime: (Int, Int)) {
        updateTableViewAnimated(photoCountsAtDifferentTime)
    }
}

// MARK: - Extensions + Internal ImageListViewController -> ImageListCellDelegate Conformance
extension ImageListViewController: ImagesListCellDelegate {
    func didTapLike(_ cell: ImagesListCell) {
        guard
            let indexPath = tableView.indexPath(for: cell)
        else { return }
        
        presenter?.didTapLike(
            for: indexPath.row,
            changeCellLikeState: { state in
                cell.setIsLiked(state)
            }
        )
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
        let photo = presenter?.photos[safe: indexPath.row]
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
        let imageSize = presenter?.photos[safe: indexPath.row]?.size ?? .zero
        
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
        presenter?.tableView(willDisplayCellAt: indexPath.row)
    }
}

// MARK: - Extensions + Intrnal ImageListViewController -> UITableViewDataSource Conformance
extension ImageListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        presenter?.photos.count ?? 0
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

        let photo = presenter?.photos[safe: indexPath.row]
        cell.configureListCell(photo: photo)
        cell.delegate = self
        return cell
    }
}

// MARK: - Extensions + Private ImageListViewController View Updates
private extension ImageListViewController {
    func updateTableViewAnimated(_ photoCountsAtDifferentTime: (Int, Int)) {
        let (oldPhotoCount, newPhotoCount) = photoCountsAtDifferentTime
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
        tableView.accessibilityIdentifier = AccessibilityElement.tableViewId.rawValue
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
