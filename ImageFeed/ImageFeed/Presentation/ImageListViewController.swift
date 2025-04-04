import UIKit

final class ImageListViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Contants
    private var photosNames: [String] = (0..<20).map { "\($0)" }
    private let singleImageSegueIdentifier = "ShowSingleImage"
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .ypBlack
    }
}

extension ImageListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == singleImageSegueIdentifier {
            guard
                let indexPath = sender as? IndexPath,
                let destinationViewController = segue.destination as? SingleImageViewController
            else {
                assertionFailure("Ivalid Segue Destination")
                return
            }
            
            let image = UIImage(named: photosNames[safe: indexPath.row] ?? "")
            destinationViewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Extensions + Internal UITableViewDelegate Conformance
extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: singleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let cell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let photoName = photosNames[safe: indexPath.row] ?? ""
        cell.configureListCell(with: photoName)
        return cell
    }
}
