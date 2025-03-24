// TODO: - future MVP implementation


//import UIKit
//
//protocol PresenterDelegate: AnyObject {
//    
//}
//
//protocol PresenterProtocol: UITableViewDelegate, UITableViewDataSource {
//    
//}
//
//final class Presenter: PresenterProtocol {
//    
//    weak var delegate: PresenterDelegate?
//    let photosNames: [String]
//    
//    init(delegate: PresenterDelegate?) {
//        self.delegate = delegate
//        
//        photosNames = (0..<20).map{ "\($0)" }
//    }
//    
//}
//
//// MARK: - Extensions + Private Helpers
//private extension Presenter {
//    var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//        formatter.timeStyle = .none
//        return formatter
//    }
//    
//    var currentDateString: String {
//        dateFormatter.string(from: Date())
//    }
//}
//
//// MARK: - Extensions + Internal UITableViewDelegate Conformance
//extension Presenter: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            return 0
//        }
//        
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let imageWidth = image.size.width
//        let scale = imageViewWidth / imageWidth
//        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
//        return cellHeight
//    }
//}
//
//// MARK: - Extensions + Intrnal UITableViewDataSource Conformance
//extension Presenter: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
//        
//        guard let cell = cell as? ImagesListCell else {
//            return UITableViewCell()
//        }
//        
//        configureListCell(for: cell, with: indexPath)
//        return cell
//    }
//    
//    private func configureListCell(for cell: ImagesListCell, with indexPath: IndexPath) {
//        
//    }
//}
