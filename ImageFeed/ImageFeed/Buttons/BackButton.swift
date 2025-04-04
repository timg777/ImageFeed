import UIKit

final class BackButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButton() {
        setImage(UIImage(systemName: "chevron.left"), for: .normal)
        tintColor = .ypWhite
        imageView?.contentMode = .scaleAspectFit
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc private func tapped() {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let navigationController = responder as? UINavigationController {
                navigationController.popViewController(animated: true)
                navigationController.tabBarController?.tabBar.isHidden = false
                return
            }
        }
    }
}
