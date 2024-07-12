import UIKit
import Alamofire

class ApiServices {
    static func fetchMovies(page: Int, completion: @escaping (Result<[MovieCard], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(Constants.apiKey)&page=\(page)"
        
        AF.request(urlString).responseDecodable(of: MovieResponse.self) { response in
            if let error = response.error {
                print("fetchMovies error: \(error.localizedDescription)")
                print("fetchMovies URL: \(urlString)")
            }
            
            switch response.result {
            case .success(let movieResponse):
                var movies = movieResponse.results
                fetchWatchlist { result in
                    switch result {
                    case .success(let watchlist):
                        movies = updateMovieListWithWatchlist(movies, watchlist: watchlist)
                        completion(.success(movies))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func fetchWatchlist(completion: @escaping (Result<[Int], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/account/21351733/watchlist/movies?"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.accessToken)"
        ]
        
        AF.request(urlString, headers: headers).responseDecodable(of: MovieResponse.self) { response in
            if let error = response.error {
                print("fetchWatchlist error: \(error.localizedDescription)")
                print("fetchWatchlist URL: \(urlString)")
            }
            
            switch response.result {
            case .success(let watchlistResponse):
                let watchlist = watchlistResponse.results.map { $0.id }
                completion(.success(watchlist))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func updateMovieListWithWatchlist(_ movies: [MovieCard], watchlist: [Int]) -> [MovieCard] {
        return movies.map { movie in
            var updatedMovie = movie
            updatedMovie.isInWatchlist = watchlist.contains(movie.id)
            return updatedMovie
        }
    }
    
    static func updateMovieListWithFavoritelist(_ movies: [MovieCard], favoritelist: [Int]) -> [MovieCard] {
        return movies.filter { favoritelist.contains($0.id) }
    }
    
    static func fetchFavoriteList(completion: @escaping (Result<[Int], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/account/21351733/favorite/movies?"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.accessToken)"
        ]
        
        AF.request(urlString, headers: headers).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let favoritelistResponse):
                let favoriteIds = favoritelistResponse.results.map { $0.id }
                completion(.success(favoriteIds))
            case .failure(let error):
                print("Error fetching favorite list: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    static func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(Constants.apiKey)"
        
        AF.request(urlString).responseDecodable(of: MovieDetail.self) { response in
            switch response.result {
            case .success(let movieDetail):
                completion(.success(movieDetail))
            case .failure(let error):
                print("Error fetching movie details: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    static func addToWatchlist(movieId: Int, isOnWatchlist: Bool, completion: @escaping (Result<WatchlistResponse, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/account/21351733/watchlist?"
        let parameters: [String: Any] = [
            "media_type": "movie",
            "media_id": movieId,
            "watchlist": !isOnWatchlist
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.accessToken)",
            "Content-Type": "application/json;charset=utf-8"
        ]
                
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: WatchlistResponse.self) { response in
            switch response.result {
            case .success(let watchlistResponse):
                print("API: \(isOnWatchlist)")
                print(watchlistResponse.statusMessage)
                completion(.success(watchlistResponse))
            case .failure(let error):
                print("Error adding to watchlist: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    static func addToFavoriteList(movieId: Int, isInFavoriteList: Bool, completion: @escaping (Result<FavoritelistResponse, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/account/21351733/favorite?"
        let parameters: [String: Any] = [
            "media_type": "movie",
            "media_id": movieId,
            "favorite": !isInFavoriteList
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.accessToken)",
            "Content-Type": "application/json;charset=utf-8"
        ]
        
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: FavoritelistResponse.self) { response in
            switch response.result {
            case .success(let favoritelistResponse):
                completion(.success(favoritelistResponse))
            case .failure(let error):
                print("Error adding to favorite list: \(error)")
                completion(.failure(error))
            }
        }
    }
}
