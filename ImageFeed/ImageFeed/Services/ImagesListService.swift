import Foundation
import KeychainWrapper

final class ImagesListService: ImagesListServiceProtocol {
    
    static let shared = ImagesListService()
    private init() {}
    
    private(set) var imagesFetchingTask: URLSessionTask?
    private(set) var imageLikeFetchingTask: URLSessionTask?
    private(set) var photos = [Photo]()
    
    private(set) var lastLoadedPage: Int?
    
//    func fetchPhotosNextPage(completion: @escaping (Result<Void, Error>) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
//            var resultPhotos = Set<Photo>()
//            stubPhotos.forEach {
//                resultPhotos.insert($0)
//            }
//            DispatchQueue.main.async { [weak self] in
//                guard let self else { return }
//                photos.append(contentsOf: resultPhotos.shuffled())
//                completion(.success(()))
//                
//                NotificationCenter.default
//                    .post(
//                        name: .imagesListServicePhotosDidChangeNotification,
//                        object: self
//                    )
//            }
//        }
//    }
    
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
                        let resultPhotos = unsplashPhotos.map { $0.convert() }.dropFirst()
                        
                        lastLoadedPage +=? 1
                        photos.append(contentsOf: resultPhotos)
                        completion(.success(()))
                        NotificationCenter.default
                            .post(
                                name: .imagesListServicePhotosDidChangeNotification,
                                object: self
                            )

                    case .failure(let error):
                        logErrorToSTDIO(
                            errorDescription: error.tracedDescription
                        )
                        completion(.failure(error))
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
                    case .success(let UnsplashPhotoLikeResult):
                        completion(.success(()))
                        updatePhoto(UnsplashPhotoLikeResult.photo.convert(), at: photoIndex)
                        
                    case .failure(let error):
                        completion(.failure(error))
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
    @MainActor
    func updatePhoto(_ photo: Photo, at index: Int) {
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

fileprivate let stubPhotos = [
    Photo(
        id: "0",
        size: .init(
            width: 4140,
            height: 2160
        ),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURLString: "https://plus.unsplash.com/premium_photo-1748152778956-c4accfc55249?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyfHx8ZW58MHx8fHx8",
        largeImageURLString: "https://plus.unsplash.com/premium_photo-1748152778956-c4accfc55249?q=80&w=4140&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        isLiked: Bool.random()
    ),
    Photo(
        id: "1",
        size: .init(
            width: 4140,
            height: 2160
        ),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURLString: "https://images.unsplash.com/photo-1747747004644-4ab29224deee?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzfHx8ZW58MHx8fHx8",
        largeImageURLString: "https://images.unsplash.com/photo-1747747004644-4ab29224deee?q=80&w=4140&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        isLiked: Bool.random()
    ),
    Photo(
        id: "2",
        size: .init(
            width: 4287,
            height: 2200
        ),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURLString: "https://images.unsplash.com/photo-1748033766479-fa6b0f9f6b33?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw0fHx8ZW58MHx8fHx8",
        largeImageURLString: "https://images.unsplash.com/photo-1748033766479-fa6b0f9f6b33?q=80&w=4287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        isLiked: Bool.random()
    ),
    Photo(
        id: "3",
        size: .init(
            width: 2488,
            height: 2250
        ),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURLString: "https://plus.unsplash.com/premium_photo-1664127534631-f23f786af39d?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw2fHx8ZW58MHx8fHx8",
        largeImageURLString: "https://plus.unsplash.com/premium_photo-1664127534631-f23f786af39d?q=80&w=2488&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        isLiked: Bool.random()
    ),
    Photo(
        id: "4",
        size: .init(
            width: 4333,
            height: 2300
        ),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURLString: "https://plus.unsplash.com/premium_photo-1748204460747-165461dde421?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMHx8fGVufDB8fHx8fA%3D%3D",
        largeImageURLString: "https://plus.unsplash.com/premium_photo-1748204460747-165461dde421?q=80&w=4333&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        isLiked: Bool.random()
    ),
    Photo(
        id: "5",
        size: .init(
            width: 4287,
            height: 2200
        ),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURLString: "https://images.unsplash.com/photo-1748324687714-1ca839539bca?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMnx8fGVufDB8fHx8fA%3D%3D",
        largeImageURLString: "https://images.unsplash.com/photo-1748324687714-1ca839539bca?q=80&w=4287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        isLiked: Bool.random()
    ),
    Photo(
        id: "6",
        size: .init(
            width: 3861,
            height: 4120
        ),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURLString: "https://images.unsplash.com/photo-1747491681738-d0ed9a30fed3?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxNnx8fGVufDB8fHx8fA%3D%3D",
        largeImageURLString: "https://images.unsplash.com/photo-1747491681738-d0ed9a30fed3?q=80&w=3861&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        isLiked: Bool.random()
    ),
    Photo(
        id: "7",
        size: .init(
            width: 3712,
            height: 4100
        ),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURLString: "https://images.unsplash.com/photo-1747734786792-317d1d8e8690?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyMHx8fGVufDB8fHx8fA%3D%3D",
        largeImageURLString: "https://images.unsplash.com/photo-1747734786792-317d1d8e8690?q=80&w=3712&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        isLiked: Bool.random()
    )
]
