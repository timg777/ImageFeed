import UIKit

final class ViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    let photosNames: [String] = (0..<20).map { "\($0)" }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Extensions + Private Helpers
private extension ViewController {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: GlobalNamespace.localizationIdentifier)
        return formatter
    }
    
    var currentDateString: String {
        dateFormatter.string(from: Date()).replacingOccurrences(of: "г.", with: "")
    }
}

// MARK: - Extensions + Internal UITableViewDelegate Conformance
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosNames[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = GlobalNamespace.imageInsets
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

// MARK: - Extensions + Intrnal UITableViewDataSource Conformance
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let cell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configureListCell(for: cell, with: indexPath)
        return cell
    }
    
    private func configureListCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosNames[safe: indexPath.row] ?? "") else {
            return
        }
        
        cell.cellImage.image = image
        cell.dateLabel.text = currentDateString

        let likeImage = UIImage(named: indexPath.row % 2 == 0 ? "Like_on" : "Like_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}
