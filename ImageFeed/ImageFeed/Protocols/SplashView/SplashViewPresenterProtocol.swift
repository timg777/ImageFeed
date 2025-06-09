protocol SplashViewPresenterProtocol: AnyObject {
    var view: SplashViewControllerProtocol? { get set }
    func viewDidLoad()
    func viewDidAppear()
    func didAuthenticate(
        _ vc: AuthViewController,
        with token: String
    )
    func didFailAuthentication(with error: any Error)
    
    func fetchUserProfile(
        by token: String,
        completion: ((String) -> Void)?
    )
    func fetchUserProfilePhoto(
        by token: String,
        username: String,
        completion: (() -> Void)?
    )
}
