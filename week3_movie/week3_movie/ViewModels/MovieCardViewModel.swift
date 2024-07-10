    import Foundation

    class MovieCardViewModel {
        
        var movies: [MovieCard] = []
        var watchlist: [Int] = []
        var currentPage = 1
        var isLoading = false
        
        func fetchMovies(page: Int, completion: @escaping (Result<[MovieCard], Error>) -> Void) {
            guard !isLoading else { return }
            isLoading = true
            
            ApiServices.fetchMovies(page: page) { [weak self] result in
                guard let self = self else { return }
                defer {
                    self.isLoading = false
                }
                
                switch result {
                case .success(let fetchedMovies):
                    self.movies.append(contentsOf: fetchedMovies)
                    self.updateMovieListWithWatchlist()
                    completion(.success(fetchedMovies))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        func fetchWatchlist(completion: @escaping (Result<[Int], Error>) -> Void) {
            ApiServices.fetchWatchlist { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let watchlist):
                    self.watchlist = watchlist
                    self.updateMovieListWithWatchlist()
                    completion(.success(watchlist))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        func updateMovieListWithWatchlist() {
            self.movies = ApiServices.updateMovieListWithWatchlist(self.movies, watchlist: self.watchlist)
        }
    }
