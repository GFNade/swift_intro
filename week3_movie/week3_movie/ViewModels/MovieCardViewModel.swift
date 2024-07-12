import Foundation
import RxSwift

class MovieCardViewModel {
    
    var movies: [MovieCard] = []
    var currentPage = 1
    var isLoading = false
    private let disposeBag = DisposeBag()
    
    let watchlistSubject = BehaviorSubject<[Int]>(value: [])
    let favoritelistSubject = BehaviorSubject<[Int]>(value: [])
    
    init() {
        setupBindings()
    }
    
    func setupBindings() {
        MovieDetailViewModel.watchlistSubject
            .subscribe(onNext: { [weak self] watchlist in
                self?.watchlistSubject.onNext(watchlist)
                self?.updateMovieListWithWatchlist()
            })
            .disposed(by: disposeBag)
        
        MovieDetailViewModel.favoritelistSubject
            .subscribe(onNext: {[weak self] favoritelist in
                self?.favoritelistSubject.onNext(favoritelist)
            })
            .disposed(by: disposeBag)
    }
    
    var watchlist: Observable<[Int]> {
        return watchlistSubject.asObservable()
    }
    
    func fetchWatchlist(completion: @escaping (Result<[Int], Error>) -> Void) {
        ApiServices.fetchWatchlist { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let watchlist):
                self.watchlistSubject.onNext(watchlist)
                self.updateMovieListWithWatchlist()
                completion(.success(watchlist))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
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
                if page == 1 {
                    self.movies = fetchedMovies
                } else {
                    self.movies.append(contentsOf: fetchedMovies) 
                }
                self.updateMovieListWithWatchlist()
                completion(.success(fetchedMovies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateMovieListWithWatchlist() {
        do {
            let watchlist = try self.watchlistSubject.value()
            self.movies = ApiServices.updateMovieListWithWatchlist(self.movies, watchlist: watchlist)
        } catch {
            print("Error updating movie list with watchlist: \(error)")
        }
    }
}
