//
//  MovieCardExtension.swift
//  week3_movie
//
//  Created by NhanNT on 09/07/2024.
//

import Foundation
import UIKit

extension MovieCardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCardCell", for: indexPath) as! MovieCardCell
        if (viewModel.movies.count > 0) {
            let movie = viewModel.movies[indexPath.row]
            cell.loadData(movie: movie)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
            
        if offsetY > contentHeight - screenHeight && !viewModel.isLoading {
            viewModel.currentPage += 1
            viewModel.fetchMovies(page: viewModel.currentPage) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movies[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) as? MovieCardCell {
            cell.posterImageView.heroID = "poster_\(selectedMovie.id)"
            performSegue(withIdentifier: "MovieDetailViewController", sender: selectedMovie.id)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailViewController" {
            if let movieDetailVC = segue.destination as? MovieDetailViewController,
               let movieId = sender as? Int {
                movieDetailVC.movieId = movieId
                movieDetailVC.viewModel.isOnWatchlist = viewModel.watchlist.contains(movieId)
            }
        }
    }
}
