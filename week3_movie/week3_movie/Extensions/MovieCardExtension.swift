import UIKit

extension MovieCardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCardCell", for: indexPath) as! MovieCardCell
        if indexPath.row < viewModel.movies.count {
            let movie = viewModel.movies[indexPath.row]
            cell.loadData(movie: movie)
            cell.posterImageView.heroID = "poster_\(movie.id)"
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
        if viewModel.movies.indices.contains(indexPath.row) {
            let selectedMovie = viewModel.movies[indexPath.row]
            if tableView.cellForRow(at: indexPath) is MovieCardCell {
                performSegue(withIdentifier: "MovieDetailViewController", sender: selectedMovie.id)
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
