import Foundation
import KeychainWrapper

protocol ImagesListServiceProtocol {
    static var imagesListServiceDidChangeNotification: Notification.Name { get }
    var task: URLSessionTask? { get }
    var photos: [Photo] { get }
    var lastLoadedPage: Int? { get }
    func fetchPhotosNextPage()
}

final class ImagesListService: ImagesListServiceProtocol {
    
    private(set) var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    
    private(set) var lastLoadedPage: Int?
    
    static let imagesListServiceDidChangeNotification = Notification.Name(rawValue: GlobalNamespace.NorificationName.imagesListServiceDidChangeNotification.rawValue)
    
    func fetchPhotosNextPage() {
        
        if let _ = task {
            logErrorToSTDIO(
                errorDescription: "Previous task is still running"
            )
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        lastLoadedPage = nextPage
        
        let urlString = "https://api.unsplash.com/photos"
        let parameters: [String:String] = [
            "client_id": Constants.accessKey,
            "page": String(nextPage),
            "per_page": String(GlobalNamespace.imagesListServicePhotosPerPageCount),
        ]
        let thumbPhotoSizeStrategy: UnsplashPhoto.UnsplashPhotoURLsKind = .thumb
        let largePhotoSizeStrategy: UnsplashPhoto.UnsplashPhotoURLsKind = .full

        do {
            task = try URLSession.shared.objectTask(
                urlString: urlString,
                httpMethod: .GET,
                parameters: parameters
            ) { [weak self] (result: Result<[UnsplashPhoto], Error>) in
                guard let self else { return }
                switch result {
                case .success(let unsplashPhotos):
                    unsplashPhotos.forEach { photo in
                        
                        let size = CGSize(
                            width: photo.width,
                            height: photo.height
                        )
                        let createAt = Date().convertToDate(with: photo.created_at ?? "")
                        let thumbImageURLString = photo.urls[
                            thumbPhotoSizeStrategy.rawValue,
                            default: ""
                        ]
                        let largeImageURLString = photo.urls[
                            largePhotoSizeStrategy.rawValue,
                            default: ""
                        ]
                        
                        self.photos.append(
                            .init(
                                id: photo.id,
                                size: size,
                                createdAt: createAt,
                                welcomeDescription: photo.description,
                                thumbImageURLString: thumbImageURLString,
                                largeImageURLString: largeImageURLString,
                                isLiked: photo.liked_by_user
                            )
                        )
                    }
                    
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.imagesListServiceDidChangeNotification,
                            object: self,
                            userInfo: [:]
                        )

                    task?.cancel()
                    task = nil
                    
                case .failure(let error):
                    logErrorToSTDIO(
                        errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
                    )
                    task?.cancel()
                    task = nil
                }
            }
            
            task?.resume()
        } catch {
            NotificationCenter.default
                .post(
                    name: ImagesListService.imagesListServiceDidChangeNotification,
                    object: self,
                    userInfo: [:]
                )
            logErrorToSTDIO(
                errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
            )
            task?.cancel()
            task = nil
        }
    }
}
