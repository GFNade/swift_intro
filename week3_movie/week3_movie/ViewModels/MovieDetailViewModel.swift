import Foundation
import Alamofire
import RxSwift

class MovieDetailViewModel {
    
    var favoritelist: [Int] = []
    var isOnWatchlist = false
    var isInFavoriteList = false
    
    func fetchFavoriteList(completion: @escaping (Result<[Int], Error>) -> Void) {
        ApiServices.fetchFavoriteList { result in
            completion(result)
        }
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        ApiServices.fetchMovieDetails(movieId: movieId) { result in
            completion(result)
        }
    }
    
    func addToWatchlist(movieId: Int, isOnWatchlist: Bool, completion: @escaping (Result<WatchlistResponse, Error>) -> Void) {
        ApiServices.addToWatchlist(movieId: movieId, isOnWatchlist: isOnWatchlist) { result in
            completion(result)
        }
    }
    
    func addToFavoriteList(movieId: Int, isInFavoriteList: Bool, completion: @escaping (Result<FavoritelistResponse, Error>) -> Void) {
        ApiServices.addToFavoriteList(movieId: movieId, isInFavoriteList: isInFavoriteList) { result in
            completion(result)
        }
    }
}

