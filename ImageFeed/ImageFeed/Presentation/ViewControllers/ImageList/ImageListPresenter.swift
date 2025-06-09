import Foundation

final class ImageListPresenter: ImageListPresenterProtocol {
    
    // MARK: - Private Contants
    private let imagesListService: ImagesListServiceProtocol = ImagesListService.shared
    
    // MARK: - Internal Properties
    weak var view: ImageListViewControllerProtocol?
    var token: String? {
        SecureStorage.shared.getToken()
    }
    
    // MARK: - Private Properties
    private(set) var photos = [Photo]()
    private var alertPresenter: AlertPresenterProtocol?
    private lazy var observerObject: Observer? = {
        try? Observer(
            self,
            from: [
                ImagesListService.self
            ],
            for: [
                .imagesListServicePhotosDidChangeNotification
            ]
        )
    }()
    
    // MARK: - Presenter Life Cycles
    func viewDidLoad() {
        addObserverObject()
        alertPresenter = AlertPresenter()

        tableView(willDisplayCellAt: photos.count - 1)
    }
    
    deinit {
        NotificationCenterManager.shared.removeObserver(observerObject)
    }
    
}

// MARK: - Extensions + Private ImageListPresneter Methods
private extension ImageListPresenter {
    func addObserverObject() {
        if let observerObject {
            NotificationCenterManager.shared.addObserver(observerObject)
        } else {
            logErrorToSTDIO(
                errorDescription: "Failed to create observer object for notifications"
            )
        }
    }
}

// MARK: - Extensions + Internal ImageListPresenter -> ImageListPresenterProtocol Conformance
extension ImageListPresenter {
    func didTapLike(
        for index: Int,
        changeCellLikeState: @escaping (Bool) -> Void
    ) {
        guard
            let token = token
        else { return }
        
        view?.lockUI()
        imagesListService.changeLike(
            token: token,
            photoIndex: index
        ) { [weak self, weak view] result in
            guard let view else { return }
            view.unlockUI()
            guard let self else { return }
            switch result {
            case .success:
                photos = imagesListService.photos
                changeCellLikeState(photos[index].isLiked)
            case .failure:
                alertPresenter?.present(present: view.present)
            }
        }
    }
    
    func tableView(willDisplayCellAt index: Int) {
        if index == photos.count - 1 {
            guard photos.count < imagesListService.photos.count || photos.isEmpty else { return }
            view?.lockUI()
            imagesListService.fetchPhotosNextPage { [weak self, weak view] result in
                guard let view else { return }
                view.unlockUI()
                guard let self else { return }
                switch result {
                case .success:
                    break
                case .failure:
                    alertPresenter?.present(present: view.present)
                }
            }
        }
    }
}

// MARK: - Extensions + Internal ImageListPresenter -> NotificationObserver Conformance
extension ImageListPresenter: NotificationObserver {
    func handleNotification(_ notification: Notification) {
        if notification.name == .imagesListServicePhotosDidChangeNotification {
            let oldPhotoCount = photos.count
            let newPhotoCount = imagesListService.photos.count
            photos = imagesListService.photos
            
            view?.updateTableViewIfNeeded(
                photoCountsAtDifferentTime: (oldPhotoCount, newPhotoCount)
            )
        }
    }
}
