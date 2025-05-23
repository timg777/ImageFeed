import UIKit

final class ImageListViewController: UIViewController {

    // MARK: - Private Views
    private let tableView = UITableView()
    
    // MARK: - Private Contants
    private var photosNames: [String] = (0..<20).map { "\($0)" }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        setUpViews()
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
        singleImageViewController.image = UIImage(named: photosNames[safe: indexPath.row] ?? "")
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
        guard let image = UIImage(named: photosNames[safe: indexPath.row] ?? "") else {
            return 0
        }
        
        let imageInsets = GlobalNamespace.imageInsets
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / (imageWidth == 0 ? 1 : imageWidth)
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

// MARK: - Extensions + Intrnal UITableViewDataSource Conformance
extension ImageListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        photosNames.count
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

        
        let photoName = photosNames[safe: indexPath.row] ?? ""
        cell.configureListCell(with: photoName)
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
