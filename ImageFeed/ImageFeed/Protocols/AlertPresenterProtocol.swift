import UIKit

protocol AlertPresenterProtocol {
    @MainActor
    @preconcurrency
    func present(
        kind: AlertKind,
        present: @MainActor (
            UIViewController,
            Bool,
            (() -> Void)?
        ) -> Void,
        _ completion: (() -> Void)?
    )
}
