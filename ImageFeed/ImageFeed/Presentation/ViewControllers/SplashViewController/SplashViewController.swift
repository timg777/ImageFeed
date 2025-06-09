import UIKit
import WebKit
import Kingfisher

final class SplashViewController: UIViewController & SplashViewControllerProtocol {
    
    // MARK: - Private Views
    private lazy var launchImage: UIImageView = {
        .init()
    }()
    
    // MARK: - Internal Properties
    var presenter: SplashViewPresenterProtocol?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.viewDidLoad()
        }
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.viewDidAppear()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - Extensions + Internal SplashViewController Appearance Control
extension SplashViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: - Extensions + Internal SplashViewController -> AuthViewControllerDelegate Conformance
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, with token: String) {
        presenter?.didAuthenticate(vc, with: token)
    }
    
    func didFailAuthentication(with error: any Error) {
        presenter?.didFailAuthentication(with: error)
    }
}

// MARK: - Extensions + Internal SplashViewController -> SplashViewControllerProtocol Conformance
extension SplashViewController {
    func routeToAuthentication() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        
        authViewController.modalPresentationStyle = .fullScreen
        present(
            authViewController,
            animated: true
        )
    }
    
    func routeToMain() {
        let tabBarController = TabBarController()
        
        tabBarController.modalPresentationStyle = .fullScreen
        present(
            tabBarController,
            animated: false
        )
    }
}

// MARK: - Extensions + Private SplashViewController Setting Up Views
private extension SplashViewController {
    func setUpViews() {
        view.backgroundColor = .ypBlack
        setUpLaunchImage()
    }
    
    func setUpLaunchImage() {
        launchImage.image = UIImage(resource: .launchScreenVector)
        launchImage.layer.cornerRadius = UserProfileViewConstraints.userProfileImage_LayerCornerRadiusConstant.rawValue
        launchImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(launchImage)
        
        NSLayoutConstraint.activate([
            launchImage.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            launchImage.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),
            launchImage.heightAnchor.constraint(
                equalToConstant: UserProfileViewConstraints.userProfileImage_WidthHeightConstant.rawValue
            ),
            launchImage.widthAnchor.constraint(
                equalTo: launchImage.heightAnchor
            ) // 1:1
        ])
    }
}
