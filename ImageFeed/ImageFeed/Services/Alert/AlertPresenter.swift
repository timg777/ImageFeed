import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    /// Retry alert
    @MainActor
    @preconcurrency
    func present(
        primaryAction: @escaping () -> Void,
        retryAction: @escaping () -> Void,
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void
    ) {
        let alert = UIAlertController(
            title: "Что-то пошло не так.",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        let primaryAction = UIAlertAction(
            title: "Не надо",
            style: .default
        ) { _ in
            alert.dismiss(
                animated: true,
                completion: primaryAction
            )
        }
        let retryAction = UIAlertAction(
            title: "Повторить",
            style: .default
        ) { _ in
            alert.dismiss(
                animated: true,
                completion: retryAction
            )
        }
        
        primaryAction.accessibilityIdentifier = AccessibilityElement.alertOKButton.rawValue
        alert.addAction(primaryAction)
        alert.addAction(retryAction)
        
        present(alert, true, nil)
    }
    
    /// Auth error alert
    @MainActor
    @preconcurrency
    func present(
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void,
        action: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )

        let action = UIAlertAction(
            title: "Ок",
            style: .default
        ) { _ in
            alert.dismiss(
                animated: true,
                completion: action
            )
        }
        
        action.accessibilityIdentifier = AccessibilityElement.alertOKButton.rawValue
        alert.addAction(action)
        
        present(alert, true, nil)
    }
    
    /// Any error primary alert
    @MainActor
    @preconcurrency
    func present(
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void
    ) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось выполнить запрос",
            preferredStyle: .alert
        )

        let action = UIAlertAction(
            title: "Ок",
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
        }
        
        action.accessibilityIdentifier = AccessibilityElement.alertOKButton.rawValue
        alert.addAction(action)
        
        present(alert, true, nil)
    }
    
    /// Logout alert
    @MainActor
    @preconcurrency
    func present(
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void,
        yesButtonAction: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )

        let yesButtonAction = UIAlertAction(
            title: "Да",
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
            yesButtonAction()
        }
        
        let noButtonAction = UIAlertAction(
            title: "Нет",
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
        }
        
        yesButtonAction.accessibilityIdentifier = AccessibilityElement.alertOKButton.rawValue
        alert.addAction(yesButtonAction)
        alert.addAction(noButtonAction)
        
        present(alert, true, nil)
    }
}
