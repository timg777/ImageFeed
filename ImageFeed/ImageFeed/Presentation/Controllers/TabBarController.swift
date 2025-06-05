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
        let imageListViewController = ImageListViewController()
        imageListViewController.tabBarItem =
        UITabBarItem(
            title: "",
            image: UIImage(resource: .stackActive),
            selectedImage: nil
        )
        
        let userProfileViewController = UserProfileViewController()
        userProfileViewController.tabBarItem =
        UITabBarItem(
            title: "",
            image: UIImage(resource: .stackNoActive),
            selectedImage: nil
        )
        
        self.viewControllers = [imageListViewController, userProfileViewController]
    }
}

