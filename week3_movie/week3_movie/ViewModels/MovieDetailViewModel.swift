import Foundation
import Alamofire
import RxSwift
import RxCocoa

class MovieDetailViewModel {
    static let shared = MovieDetailViewModel()

    var isOnWatchlist = false
    var isInFavoriteList = false
    
    static let watchlistSubject = BehaviorSubject<[Int]>(value: [])
    var watchlist: Observable<[Int]> {
        return MovieDetailViewModel.watchlistSubject.asObservable()
    }
    
    static let favoritelistSubject = BehaviorSubject<[Int]>(value: [])
    var favoritelist: Observable<[Int]> {
        return MovieDetailViewModel.favoritelistSubject.asObservable()
    }
    
    func fetchWatchlist() {
        ApiServices.fetchWatchlist { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let watchlist):
                print("truyen \(watchlist)")
                MovieDetailViewModel.watchlistSubject.onNext(watchlist)
            case .failure(let error):
                MovieDetailViewModel.watchlistSubject.onError(error)
            }
        }
    }
    
    func fetchFavoriteList() {
        ApiServices.fetchFavoriteList { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let favoritelist):
                MovieDetailViewModel.favoritelistSubject.onNext(favoritelist)
            case .failure(let error):
                MovieDetailViewModel.favoritelistSubject.onError(error)
            }
        }
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        ApiServices.fetchMovieDetails(movieId: movieId) { result in
            completion(result)
        }
    }
        
    func addToWatchlist(movieId: Int, isOnWatchlist: Bool, completion: @escaping (Result<WatchlistResponse, Error>) -> Void) {
        ApiServices.addToWatchlist(movieId: movieId, isOnWatchlist: isOnWatchlist) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.fetchWatchlist() 
                completion(.success(WatchlistResponse(statusCode: 1, statusMessage: "Add/Delete to watchlist successfully")))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addToFavoriteList(movieId: Int, isInFavoriteList: Bool, completion: @escaping (Result<FavoritelistResponse, Error>) -> Void) {
        ApiServices.addToFavoriteList(movieId: movieId, isInFavoriteList: isInFavoriteList) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.fetchFavoriteList()
                completion(.success(FavoritelistResponse(statusCode: 1, statusMessage: "Add/Delete to favoritelist successfully")))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
