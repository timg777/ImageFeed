import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Inernal Properties
    var image: UIImage? {
        didSet {
            guard let image, isViewLoaded else { return }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - IB Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!

    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpImage()
        setUpButtons()
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
        return imageView
    }
}

// MARK: - Extensions + Private IBActions
private extension SingleImageViewController {
    @IBAction func didTapLikeButton(_ sender: Any) {}
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let activityController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(activityController, animated: true, completion: nil)
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Extensions + Private Setting Up Views
private extension SingleImageViewController {
    func setUpImage() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
    }
    
    func setUpButtons() {
        shareButton.setTitle("", for: .normal)
        shareButton.backgroundColor = .ypBlack
        shareButton.layer.cornerRadius = shareButton.frame.height / 2
        
        likeButton.setTitle("", for: .normal)
        likeButton.backgroundColor = .ypBlack
        likeButton.layer.cornerRadius = likeButton.frame.height / 2
        
        backButton.setTitle("", for: .normal)
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
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2

        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
