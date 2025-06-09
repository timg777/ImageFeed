import Foundation
import KeychainWrapper

final class ImagesListService: ImagesListServiceProtocol {
    
    // MARK: - Singletone initialization
    static let shared = ImagesListService()
    private init() {}
    
    // MARK: - Private(set) Properties
    private(set) var imagesFetchingTask: URLSessionTask?
    private(set) var imageLikeFetchingTask: URLSessionTask?
    private(set) var photos = [Photo]()
    
    private(set) var lastLoadedPage: Int?
    
    // MARK: - Private Constants
    private let dateFormatterFROM = ISO8601DateFormatter()
    private let dateFormatterTO: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}

// MARK: - Extensions + Internal ImagesListService -> ImagesListServiceProtocol Conformance
extension ImagesListService {
    func fetchPhotosNextPage(completion: @escaping (Result<Void, Error>) -> Void) {
        
        if let _ = imagesFetchingTask {
            logErrorToSTDIO(
                errorDescription: "Previous task is still running"
            )
            return
        }
        
        let urlString = Constants.Service.photos.urlString
        let parameters: [String:String] = [
            "client_id": Constants.accessKey,
            "page": String((lastLoadedPage ?? 0) + 1),
            "per_page": String(GlobalNamespace.imagesListServicePhotosPerPageCount),
        ]

        do {
            imagesFetchingTask =
            try URLSession.shared.objectTask(
                urlString: urlString,
                httpMethod: .GET,
                parameters: parameters
            ) { [weak self] (result: Result<[UnsplashPhotoResult], Error>) in
                guard let self else { return }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    switch result {
                    case .success(let unsplashPhotos):
                        let resultPhotos =
                        unsplashPhotos
                            .map { self.convert($0) }
                            .dropFirst()
                        
                        lastLoadedPage +=? 1
                        photos.append(contentsOf: resultPhotos)
                        completion(
                            .success(())
                        )
                        NotificationCenter.default
                            .post(
                                name: .imagesListServicePhotosDidChangeNotification,
                                object: self
                            )

                    case .failure(let error):
                        logErrorToSTDIO(
                            errorDescription: error.tracedDescription
                        )
                        completion(
                            .failure(error)
                        )
                    }
                
                    cancelImgesFetchingTaskIfNeeded()
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.resumeImagesFetchingTaskIfNeeded()
            }
            
        } catch {
            logErrorToSTDIO(
                errorDescription: error.tracedDescription
            )
            
            DispatchQueue.main.async { [weak self] in
                self?.cancelImgesFetchingTaskIfNeeded()
            }
        }
    }
    
    func changeLike(
        token: String,
        photoIndex: Int,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        if let _ = imageLikeFetchingTask {
            logErrorToSTDIO(
                errorDescription: "Previous task is still running"
            )
            return
        }
        
        guard let photo = photos[safe: photoIndex] else {
            logErrorToSTDIO(
                errorDescription: "IndexRange out of bounds"
            )
            return
        }
        let httpMethod: URLSession.HTTPMethod = photo.isLiked ? .DELETE : .POST

        let urlString =
        Constants
            .Service
            .like
            .urlString
            .replacingOccurrences(
                of: Constants.photoLikeReplacementString,
                with: photos[safe: photoIndex]?.id ?? "NO_ID"
            )
        
        let headers: [String:String] = [
            "Authorization": "Bearer \(token)"
        ]
        
        do {
            imageLikeFetchingTask =
            try URLSession.shared.objectTask(
                urlString: urlString,
                httpMethod: httpMethod,
                headerFields: headers
            ) { [weak self] (result: (Result<UnsplashPhotoLikeResult, Error>)) in
                guard let self else { return }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let unsplashPhotoLikeResult):
                        completion(
                            .success(())
                        )
                        updatePhoto(
                            convert(unsplashPhotoLikeResult.photo),
                            at: photoIndex
                        )
                        
                    case .failure(let error):
                        completion(
                            .failure(error)
                        )
                        logErrorToSTDIO(
                            errorDescription: error.tracedDescription
                        )
                    }
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.cancelImageLikeTaskIfNeeded()
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.resumeImageLikeTaskIfNeeded()
            }
        } catch {
            logErrorToSTDIO(
                errorDescription: error.tracedDescription
            )
            DispatchQueue.main.async { [weak self] in
                self?.cancelImageLikeTaskIfNeeded()
            }
        }
    }
}

// MARK: - Extensions + Private Helpers
private extension ImagesListService {
    func convert(_ photo: UnsplashPhotoResult) -> Photo {
        
        let thumbPhotoSizeStrategy: UnsplashPhotoResult.UnsplashPhotoURLsKind = .thumb
        let largePhotoSizeStrategy: UnsplashPhotoResult.UnsplashPhotoURLsKind = .full
        
        let size = CGSize(
            width: photo.width,
            height: photo.height
        )

        let thumbImageURLString = photo.urls[
            thumbPhotoSizeStrategy.rawValue,
            default: ""
        ]
        let largeImageURLString = photo.urls[
            largePhotoSizeStrategy.rawValue,
            default: ""
        ]
        
        var dateString = photo.createdAt
        
        if
            let _dateString = dateString,
            let date = dateFormatterFROM.date(from: _dateString)
        {
            dateString = dateFormatterTO.string(from: date)
        }
        
        return .init(
            id: photo.id,
            size: size,
            createdAt: dateString,
            welcomeDescription: photo.description,
            thumbImageURLString: thumbImageURLString,
            largeImageURLString: largeImageURLString,
            isLiked: photo.likedByUser
        )
    }
    
    @MainActor
    func updatePhoto(
        _ photo: Photo,
        at index: Int
    ) {
        guard photos[safe: index] != nil else { return }
        photos[index] = photo
    }
    
    @MainActor
    func cancelImageLikeTaskIfNeeded() {
        imageLikeFetchingTask?.cancel()
        imageLikeFetchingTask = nil
    }
    
    @MainActor
    func cancelImgesFetchingTaskIfNeeded() {
        imagesFetchingTask?.cancel()
        imagesFetchingTask = nil
    }
    
    @MainActor
    func resumeImagesFetchingTaskIfNeeded() {
        imagesFetchingTask?.resume()
    }
    
    @MainActor
    func resumeImageLikeTaskIfNeeded() {
        imageLikeFetchingTask?.resume()
    }
}
