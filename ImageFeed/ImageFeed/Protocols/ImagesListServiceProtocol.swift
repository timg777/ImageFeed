import Foundation

protocol ImagesListServiceProtocol {
    static var shared: Self { get }
    var imagesFetchingTask: URLSessionTask? { get }
    var photos: [Photo] { get }
    var lastLoadedPage: Int? { get }
    
    func fetchPhotosNextPage(completion: @escaping (Result<Void, Error>) -> Void)
    func changeLike(
        token: String,
        photoIndex: Int,
        _ completion: @escaping (Result<Void, Error>) -> Void
    )
}
