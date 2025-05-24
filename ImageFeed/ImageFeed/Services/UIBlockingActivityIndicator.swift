import UIKit
import ProgressHUD

@MainActor
final class UIBlockingActivityIndicator {
    
    private init() {
        ProgressHUD.animationType = .circleStrokeSpin
    }
    
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    static func showActivityIndicator() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismissActivityIndicator() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
