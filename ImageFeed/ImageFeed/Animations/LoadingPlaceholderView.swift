import UIKit

// MARK: - Extensions + Internal CALayer gradient animation controll
extension CALayer {
    func addGradientLoadingAnimation(cornerRadius: CGFloat = 0) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.locations = [0, 0.4, 0.8]
        gradient.colors = [
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = cornerRadius
        gradient.masksToBounds = true
        gradient.name = "loadingGradientLayer"
        addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.autoreverses = true
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, -0.4, -0]
        gradientChangeAnimation.toValue = [0, 1, 1.4]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
    
    func removeGradientAnimationSublayers() {
        sublayers?.removeAll(where: { $0.name == "loadingGradientLayer" })
    }
    
    func scaleGradientAnimationSubLayer(scaleFactor: CGFloat) {
        sublayers?.first(where: { $0.name == "loadingGradientLayer" })?.contentsScale = scaleFactor
    }
}
