import UIKit

final class TabBarController: UITabBarController {
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        configureViewControllers()
    }
    
    // MARK: - Internal View Appearance Configuration
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: - Extensions + Private TabBarController Helpers
private extension TabBarController {
    func setupAppearance() {
        let tabBarAppearance = UITabBarAppearance ()
        tabBarAppearance.configureWithOpaqueBackground ()
        tabBarAppearance.backgroundColor = .ypBlack
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .ypWhite
        tabBar.standardAppearance = tabBarAppearance
    }
    
    func configureViewControllers() {
        let imageListPresenter = ImageListPresenter()
        let imageListViewController = ImageListViewController()
        imageListViewController.presenter = imageListPresenter
        imageListPresenter.view = imageListViewController
        imageListViewController.tabBarItem =
        UITabBarItem(
            title: "",
            image: UIImage(resource: .stackNoActive),
            selectedImage: UIImage(resource: .stackActive)
        )
        
        let userProfilePresenter = UserProfilePresenter()
        let userProfileViewController = UserProfileViewController()
        userProfileViewController.presenter = userProfilePresenter
        userProfilePresenter.view = userProfileViewController
        userProfileViewController.tabBarItem =
        UITabBarItem(
            title: "",
            image: UIImage(resource: .profileNoActive),
            selectedImage: UIImage(resource: .profileActive)
        )
        
        self.viewControllers = [imageListViewController, userProfileViewController]
    }
}

