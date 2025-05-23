import UIKit
import ProgressHUD

@MainActor
final class UIBlockingActivityIndicator {
    
    static var shared = UIBlockingActivityIndicator()
    private init() {
        ProgressHUD.animationType = .circleStrokeSpin
    }
    
    private var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    func showActivityIndicator() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    func dismissActivityIndicator() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
