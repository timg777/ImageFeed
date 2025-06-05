protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController, with token: String)
    func didFailAuthentication(with error: Error)
}
