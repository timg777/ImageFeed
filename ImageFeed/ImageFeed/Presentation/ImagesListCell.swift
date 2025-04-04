import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Constants
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - IB Outlets
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    
    // MARK: - view Life Cycles
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        configureCell()
        configureCellImage()
        configureDateLabel()
        configureLikeButton()
    }
}

// MARK: - Extensions + Internal Configuration
extension ImagesListCell {
    func configureListCell(with photoName: String) {
        guard let image = UIImage(named: photoName) else {
            return
        }
        
        cellImage.image = image
        dateLabel.text = currentDateString

        let likeImage = UIImage(named: Bool.random() ? "Like_on" : "Like_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}

// MARK: - Extensions + Private Helpers
private extension ImagesListCell {
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

// MARK: - Extensions + Private Helpers
private extension ImagesListCell {
    func configureCell() {
        backgroundColor = .clear
        layer.cornerRadius = GlobalNamespace.cellCornerRadius
    }
    
    func configureCellImage() {
        cellImage.layer.cornerRadius = GlobalNamespace.cellCornerRadius
    }
    
    func configureLikeButton() {
        likeButton.imageView?.layer.shadowRadius = GlobalNamespace.likeButtonShadowRadius
        likeButton.imageView?.layer.shadowOpacity = GlobalNamespace.likeButtonShadowOpacity
        likeButton.imageView?.layer.shadowOffset = GlobalNamespace.likeButtonShadowOffset
        likeButton.imageView?.layer.shadowColor = GlobalNamespace.likeButtonShadowColor
    }
    
    func configureDateLabel() {
        // TODO: - реализовать градиент с небольшим блюром для выделения текста из изображения (знаю, что комменты нельзя вам постить, но это для меня)
//        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = dateLabel.bounds
//        dateLabel.addSubview(blurView)
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = .init(
//            x: dateLabel.bounds.minX - 8,
//            y: dateLabel.bounds.minY,
//            width: dateLabel.bounds.width + 28,
//            height: dateLabel.bounds.height
//        )
//        gradientLayer.colors = [
//            UIColor.clear.cgColor,
//            UIColor.black.cgColor,
//            UIColor.black.cgColor,
//            UIColor.clear.cgColor
//        ]
//        gradientLayer.zPosition = 0
//
//        dateLabel.layer.addSublayer(gradientLayer)
//        dateLabel.layer.zPosition = 1
    }
}
