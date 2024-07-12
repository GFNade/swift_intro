import Foundation
import RxSwift
import RxCocoa

class FavoriteCardViewModel {
    var favoriteMovies: [MovieCard] = []
    var currentPage = 1
    var isLoading = false
    
    let favoritelistSubject = BehaviorSubject<[Int]>(value: [])
    var favoritelist: Observable<[Int]> {
        return favoritelistSubject.asObservable()
    }
    let watchlistSubject = BehaviorSubject<[Int]>(value: [])

    private let disposeBag = DisposeBag()

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
            .subscribe(onNext: { [weak self] favoritelist in
                self?.favoritelistSubject.onNext(favoritelist)
                self?.updateMovieListWithFavoritelist()
            })
            .disposed(by: disposeBag)
    }
    
    func fetchFavoriteList(completion: @escaping (Result<[Int], Error>) -> Void) {
        ApiServices.fetchFavoriteList { result in
            switch result {
            case .success(let favoriteIds):
                self.favoritelistSubject.onNext(favoriteIds)
                completion(.success(favoriteIds))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchFavoriteMovies(completion: @escaping (Result<[MovieCard], Error>) -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        fetchFavoriteList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favoriteIds):
                ApiServices.fetchMovies(page: self.currentPage) { result in
                    self.isLoading = false
                    switch result {
                    case .success(let movies):
                        if self.currentPage == 1 {
                            self.favoriteMovies = movies.filter { favoriteIds.contains($0.id) }
                        } else {
                            self.favoriteMovies.append(contentsOf: movies.filter { favoriteIds.contains($0.id) })
                        }
                        self.updateMovieListWithWatchlist()
                        completion(.success(self.favoriteMovies))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                self.isLoading = false
                completion(.failure(error))
            }
        }
    }
    
    func refreshFavoriteMovies(completion: @escaping (Result<[MovieCard], Error>) -> Void) {
        currentPage = 1
        favoriteMovies.removeAll()
        fetchFavoriteMovies(completion: completion)
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
    
    func updateMovieListWithWatchlist() {
        do {
            let watchlist = try watchlistSubject.value()
            self.favoriteMovies = ApiServices.updateMovieListWithWatchlist(self.favoriteMovies, watchlist: watchlist)
        } catch {
            print("Error updating movie list with watchlist: \(error)")
        }
    }
    
    func updateMovieListWithFavoritelist() {
        do {
            let favoritelist = try favoritelistSubject.value()
            self.favoriteMovies = ApiServices.updateMovieListWithFavoritelist(self.favoriteMovies, favoritelist: favoritelist)
        } catch {
            print("Error updating movie list with favoritelist: \(error)")
        }
    }
}
