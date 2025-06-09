import UIKit
import ProgressHUD

@MainActor
final class UIBlockingActivityIndicator {
    
    // MARK: - Private Initialization
    private init() {
        ProgressHUD.animationType = .circleStrokeSpin
    }
    
    // MARK: - Private Static Properties
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }
}

// MARK: - Extensions + Internal UIBlockingActivityIndicator Static Methods
extension UIBlockingActivityIndicator {
    static func showActivityIndicator() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismissActivityIndicator() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
