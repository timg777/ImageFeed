protocol ImageListPresenterProtocol: AnyObject {
    var view: ImageListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func tableView(willDisplayCellAt index: Int)
    func didTapLike(
        for index: Int,
        changeCellLikeState: @escaping (Bool) -> Void
    )
}
