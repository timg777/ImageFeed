import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private func configure(
        header: String,
        body: String,
        buttonText: String,
        buttonTapCompletion: (() -> Void)?
    ) -> UIAlertController {
        
        let alert = UIAlertController(
            title: header,
            message: body,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: buttonText,
            style: .default
        ) { [weak self] _ in
            guard let _ = self else { return }
            buttonTapCompletion?()
        }
        action.accessibilityIdentifier = AccessibilityElement.alertOKButton.rawValue
        alert.addAction(action)
        return alert
        
    }
    
    @MainActor
    @preconcurrency
    func present(
        kind: AlertKind,
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void,
        _ completion: (() -> Void)? = nil
    ) {
        let alert = configure(
            header: kind.header,
            body: kind.body,
            buttonText: kind.buttonText,
            buttonTapCompletion: completion
        )
        present(alert, true, nil)
    }
}
