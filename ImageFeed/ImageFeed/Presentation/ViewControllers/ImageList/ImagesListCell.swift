import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Private Views
    private lazy var dateLabel: UILabel = {
        .init()
    }()
    private lazy var cellImage: UIImageView = {
        .init()
    }()
    private lazy var likeButton: UIButton = {
        .init()
    }()
    
    // MARK: - Static Constants
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - View Life Cycles
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        setUpViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectedBackgroundView?.frame = contentView.bounds.inset(by: GlobalNamespace.tableViewEdgeInsets)
        selectionStyle = .gray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - Initialization
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        setupSelectionBackground()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSelectionBackground()
    }

}

// MARK: - Extensions + Internal Configuration
extension ImagesListCell {
    func configureListCell(
        with fullPhotoURLString: String,
        dateString: String,
        imageLiked: Bool
    ) {
        guard let fullPhotoURL = URL(string: fullPhotoURLString) else {
            logErrorToSTDIO(
                errorDescription: "Failed to create URL using full user photo URL String -> \(fullPhotoURLString)"
            )
            return
        }
        
        let placeholderImage = UIImage(named: "Mark-Stub")
        
        cellImage.kf.setImage(
            with: fullPhotoURL,
            placeholder: placeholderImage
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let imageData):
                cellImage.image = imageData.image
            case .failure(let error):
                logErrorToSTDIO(
                    errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
                )
            }
        }
        
        dateLabel.text = dateString

        let likeImage = UIImage(named: imageLiked ? "Like_on" : "Like_off")
        likeButton.setImage(
            likeImage,
            for: .normal
        )
    }
    
    override func setSelected(
        _ selected: Bool,
        animated: Bool
    ) {
        super.setSelected(
            selected,
            animated: animated
        )
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            cellImage.alpha = selected ? 0.7 : 1
        }
    }
}

// MARK: - Extensions + Private Helpers
private extension ImagesListCell {
    func setupSelectionBackground() {
        let selectedBGView = UIView()
        selectedBGView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        selectedBGView.layer.cornerRadius = 20
        self.selectedBackgroundView = selectedBGView
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
}

// MARK: - Extensions + Private Setting Up Views
private extension ImagesListCell {
    func setUpViews() {
        configureCell()
        configureCellImage()
        configureLikeButton()
        
        setUpSelf()
        setUpCellImage()
        setUpDateLabel()
        setUpLikeButton()
    }
    
    func setUpSelf() {
        heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setUpDateLabel() {
        dateLabel.textColor = .ypWhite
        dateLabel.attributedText = NSAttributedString(
            string: "no date",
            attributes: [
                .foregroundColor: UIColor.ypWhite,
                .font: UIFont.systemFont(
                    ofSize: 13,
                    weight: .medium
                )
            ]
        )
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cellImage.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(
                equalTo: cellImage.leadingAnchor,
                constant: 8
            ),
            dateLabel.bottomAnchor.constraint(
                equalTo: cellImage.bottomAnchor,
                constant: -8
            )
        ])
    }
    
    func setUpCellImage() {
        cellImage.contentMode = .scaleAspectFill
        cellImage.clipsToBounds = true
        cellImage.translatesAutoresizingMaskIntoConstraints = false

        addSubview(cellImage)
        
        NSLayoutConstraint.activate([
            cellImage.widthAnchor.constraint(
                equalToConstant: frame.width
            ),
            cellImage.heightAnchor.constraint(
                equalToConstant: frame.height
            ),
            cellImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            cellImage.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            cellImage.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 0
            ),
            cellImage.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            )
        ])
    }
    
    func setUpLikeButton() {
        likeButton.setTitle(
            "",
            for: .normal
        )
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        cellImage.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(
                equalTo: cellImage.trailingAnchor
            ),
            likeButton.topAnchor.constraint(
                equalTo: cellImage.topAnchor
            ),
            likeButton.widthAnchor.constraint(
                equalToConstant: 44
            ),
            likeButton.heightAnchor.constraint(
                equalTo: likeButton.widthAnchor
            ) // 1:1
        ])
    }
}
