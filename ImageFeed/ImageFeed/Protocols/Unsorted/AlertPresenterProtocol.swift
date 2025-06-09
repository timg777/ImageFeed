import UIKit

protocol AlertPresenterProtocol {
    /// Retry alert
    @MainActor
    @preconcurrency
    func present(
        primaryAction: @escaping () -> Void,
        retryAction: @escaping () -> Void,
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void 
    )
    
    /// Auth error alert
    @MainActor
    @preconcurrency
    func present(
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void,
        action: @escaping () -> Void
    )
    
    /// Any error primary alert
    @MainActor
    @preconcurrency
    func present(
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void
    )
    
    /// Logout alert
    @MainActor
    @preconcurrency
    func present(
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void,
        yesButtonAction: @escaping () -> Void
    )
}
