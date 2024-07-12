//
//  FavoriteCardExtension.swift
//  week3_movie
//
//  Created by NhanNT on 10/07/2024.
//

import Foundation
import UIKit

extension FavoriteCardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCardCell", for: indexPath) as! MovieCardCell
        
        if indexPath.row < viewModel.favoriteMovies.count {
            let movie = viewModel.favoriteMovies[indexPath.row]
            cell.loadData(movie: movie)
            cell.posterImageView.heroID = "poster_\(movie.id)"
        } else {
            print("IndexPath \(indexPath.row) is out of range for favoriteMovies")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = viewModel.favoriteMovies[indexPath.row]
        if tableView.cellForRow(at: indexPath) is MovieCardCell {
            viewModel.fetchWatchlist { [weak self] result in
                switch result {
                case .success:
                    self?.performSegue(withIdentifier: "MovieDetailViewController", sender: selectedMovie.id)
                case .failure(let error):
                    print("Error fetching watchlist: \(error)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailViewController" {
            if let movieDetailVC = segue.destination as? MovieDetailViewController,
               let movieId = sender as? Int {
                movieDetailVC.movieId = movieId
                do {
                    let watchlist = try viewModel.watchlistSubject.value()
                    movieDetailVC.viewModel.isOnWatchlist = watchlist.contains(movieId)
                } catch {
                    print("Error retrieving watchlist: \(error)")
                    movieDetailVC.viewModel.isOnWatchlist = false
                }
                
                do {
                    let favoritelist = try viewModel.favoritelistSubject.value()
                    movieDetailVC.viewModel.isInFavoriteList = favoritelist.contains(movieId)
                } catch {
                    print("Error retrieving favoritelist: \(error)")
                    movieDetailVC.viewModel.isInFavoriteList = false
                }
            }
        }
    }
}
