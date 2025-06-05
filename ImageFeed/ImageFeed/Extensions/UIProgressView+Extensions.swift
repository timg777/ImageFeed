import UIKit

// MARK: - Extensions + Internal UIProgressView Helpers
extension UIProgressView {
    func resetProgress() {
        setProgress(
            0,
            animated: false
        )
    }
}
