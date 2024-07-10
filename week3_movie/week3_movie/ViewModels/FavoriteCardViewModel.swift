//
//  FavoriteCardViewModel.swift
//  week3_movie
//
//  Created by NhanNT on 09/07/2024.
//

import Foundation
import RxSwift
import RxCocoa

class FavoriteCardViewModel {
    var favoriteMovies: [MovieCard] = []
    var currentPage = 1
    var isLoading = false
    var favoritelist: [Int] = []
    var watchlist: [Int] = []
    
    func fetchFavoriteList(completion: @escaping (Result<[Int], Error>) -> Void) {
        ApiServices.fetchFavoriteList { result in
            switch result {
            case .success(let favoriteIds):
                self.favoritelist = favoriteIds
                completion(.success(favoriteIds))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchFavoriteMovies(completion: @escaping (Result<[MovieCard], Error>) -> Void) {
        guard !isLoading else { return }
        isLoading = true

        ApiServices.fetchFavoriteList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favoriteIds):
                self.favoritelist = favoriteIds
                ApiServices.fetchMovies(page: self.currentPage) { result in
                    self.isLoading = false
                    switch result {
                    case .success(let movies):
                        if self.currentPage == 1 {
                            self.favoriteMovies = movies.filter { self.favoritelist.contains($0.id) }
                        } else {
                            self.favoriteMovies.append(contentsOf: movies.filter { self.favoritelist.contains($0.id) })
                        }
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
                self.watchlist = watchlist
                self.updateMovieListWithWatchlist()
                completion(.success(watchlist))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateMovieListWithWatchlist() {
        self.favoriteMovies = ApiServices.updateMovieListWithWatchlist(self.favoriteMovies, watchlist: self.watchlist)
    }
}
