import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageListViewController = ImageListViewController()
        imageListViewController.tabBarItem =
        UITabBarItem(
            title: "",
            image: UIImage(named: "Stack-Active"),
            selectedImage: nil
        )
        
        let userProfileViewController = UserProfileViewController()
        userProfileViewController.tabBarItem =
        UITabBarItem(
            title: "",
            image: UIImage(named: "Profile-NoActive"),
            selectedImage: nil
        )
        
        self.viewControllers = [imageListViewController, userProfileViewController]
        
        tabBar.barStyle = .black
    }
    
    // MARK: - Internal View Appearance Configuration
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
