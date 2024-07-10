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
        if (viewModel.favoriteMovies.count > 0) {
            let movie = viewModel.favoriteMovies[indexPath.row]
            cell.loadData(movie: movie)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = viewModel.favoriteMovies[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) as? MovieCardCell {
            cell.posterImageView.heroID = "poster_\(selectedMovie.id)"
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
                movieDetailVC.viewModel.isOnWatchlist = viewModel.watchlist.contains(movieId)
                print("Màn favorite: movieId \(movieId) \(viewModel.watchlist.contains(movieId))")
            }
        }
    }
}
