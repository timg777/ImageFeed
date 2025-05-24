import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Private Views
    private lazy var scrollView:  UIScrollView = {
        .init()
    }()
    private lazy var imageView:  UIImageView = {
        .init()
    }()
    private lazy var shareButton:  UIButton = {
        .init()
    }()
    private lazy var backButton:  UIButton = {
        .init()
    }()
    private lazy var likeButton:  UIButton = {
        .init()
    }()
    
    // MARK: - Inernal Properties
    var image: UIImage? {
        didSet {
            guard let image, isViewLoaded else { return }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        setUpViews()
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        guard let image else { return }
        rescaleAndCenterImageInScrollView(image: image)
    }
}

// MARK: - Extensions + Conforming to UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage(animated: true)
    }
}

// MARK: - Extensions + Private IBActions
private extension SingleImageViewController {
    @objc func didTapLikeButton() {
        #warning("TODO: handle liking an image")
    }
    @objc func didTapShareButton() {
        guard let image else {
            logErrorToSTDIO(
                errorDescription: "Failed to share image because no image was set"
            )
            return
        }
        let activityController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(activityController, animated: true, completion: nil)
    }
    @objc func didTapBackButton() {
        popViewController()
    }
}

// MARK: - Extensions + Private Helpers
private extension SingleImageViewController {
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(
            maxZoomScale,
            max(
                minZoomScale,
                min(
                    hScale,
                    vScale
                )
            )
        )
        
        scrollView.setZoomScale(
            scale,
            animated: false
        )
        scrollView.layoutIfNeeded()
        
        centerImage()
    }
    
    func centerImage(animated: Bool = false) {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        
        let horizontalInset =
        max(
            0,
            (scrollViewSize.width - imageViewSize.width) / 2
        )
        let verticalInset =
        max(
            0,
            (scrollViewSize.height - imageViewSize.height) / 2
        )
        
        scrollView.contentInset =
        UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
        
        let xOffset = (scrollView.contentSize.width - scrollViewSize.width) / 2
        let yOffset = (scrollView.contentSize.height - scrollViewSize.height) / 2
        
        scrollView.setContentOffset(
            CGPoint(
                x: xOffset,
                y: yOffset
            ),
            animated: animated
        )
    }
}

// MARK: - Extensions + Private Setting Up Views
private extension SingleImageViewController {
    func setUpViews() {
        setUpScrollView()
        setUpImage()
        setUpBackButton()
        setUpShareButton()
    }
    
    func setUpImage() {
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),
            imageView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor
            ),
            imageView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),
            imageView.widthAnchor.constraint(
                equalToConstant: image.size.width
            ),
            imageView.heightAnchor.constraint(
                equalToConstant: image.size.height
            )
        ])
    }
    
    func setUpShareButton() {
        shareButton.setTitle(
            "",
            for: .normal
        )
        shareButton.setImage(
            UIImage(named: "Sharing"),
            for: .normal
        )
        shareButton.backgroundColor = .ypBlack
        shareButton.layer.cornerRadius = 22
        shareButton.addTarget(
            self,
            action: #selector(didTapShareButton),
            for: .touchUpInside
        )
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(
                equalToConstant: 44
            ),
            shareButton.heightAnchor.constraint(
                equalTo: shareButton.widthAnchor
            ), // 1:1
            shareButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            shareButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -44
            )
        ])
    }
    
    func setUpBackButton() {
        backButton.setTitle(
            "",
            for: .normal
        )
        backButton.setImage(
            UIImage(systemName: "chevron.left"),
            for: .normal
        )
        backButton.imageView?.tintColor = .ypWhite
        backButton.addTarget(
            self,
            action: #selector(didTapBackButton),
            for: .touchUpInside
        )
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(
                equalToConstant: 44
            ),
            backButton.heightAnchor.constraint(
                equalTo: backButton.widthAnchor
            ), // 1:1
            backButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            )
        ])
    }
    
    func setUpScrollView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.contentSize = image?.size ?? .zero
        scrollView.backgroundColor = .ypBlack
        scrollView.contentMode = .scaleAspectFit
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(
                equalToConstant: view.bounds.width
            ),
            scrollView.heightAnchor.constraint(
                equalToConstant: view.bounds.height
            ),
            scrollView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
}
