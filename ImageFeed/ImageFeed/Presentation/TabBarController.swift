import UIKit

final class ImageListTabBar: UITabBar {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.tintColor = .ypWhite
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.3
    }
    
}

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}
