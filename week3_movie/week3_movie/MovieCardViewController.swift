import UIKit
import Alamofire

class MovieCardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [MovieCard] = []
    var currentPage = 1
    let apiKey = "3904a5223ee034d1f223645fa76fc9fc"
    let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzOTA0YTUyMjNlZTAzNGQxZjIyMzY0NWZhNzZmYzlmYyIsIm5iZiI6MTcxOTk3OTkwMC4zMTE4NDYsInN1YiI6IjY2N2QxNzMyZDY2OTFlOTkwODc5NDE1OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZIBPHX5TyYeAkg4aAfFxdGtwjMMR4mnntCwblOjalWs"
    var isLoading = false
    var watchlist: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchWatchlist()
        fetchMovies(page: currentPage)

    }

    func fetchMovies(page: Int) {
            guard !isLoading else { return }
            isLoading = true
            
            let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=\(page)"
            
            AF.request(urlString).responseDecodable(of: MovieResponse.self) { [weak self] response in
                guard let self = self else { return }
                defer {
                    self.isLoading = false
                }
                
                switch response.result {
                case .success(let movieResponse):
                    self.movies.append(contentsOf: movieResponse.results)
                    self.movies = self.updateMovieListWithWatchlist(self.movies)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }
        }
    func fetchWatchlist() {
        let urlString = "https://api.themoviedb.org/3/account/21351733/watchlist/movies?&language=en-US&sort_by=created_at.asc"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(urlString, headers: headers).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let watchlistResponse):
                self.watchlist = watchlistResponse.results.map { $0.id }
                self.movies = self.updateMovieListWithWatchlist(self.movies)
                self.tableView.reloadData()
            case .failure(let error):
                print("Error fetching watchlist: \(error)")
            }
        }
    }
    
    func updateMovieListWithWatchlist(_ movies: [MovieCard]) -> [MovieCard] {
        return movies.map { movie in
            var updatedMovie = movie
                updatedMovie.isInWatchlist = self.watchlist.contains(movie.id)
            return updatedMovie
        }
    }
}

extension MovieCardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCardCell", for: indexPath) as! MovieCardCell
        let movie = movies[indexPath.row]
        cell.loadData(movie: movie)
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
            
        if offsetY > contentHeight - screenHeight && !isLoading {
            currentPage += 1
            fetchMovies(page: currentPage)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "MovieDetailViewController", sender: selectedMovie.id)
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailViewController" {
            if let movieDetailVC = segue.destination as? MovieDetailViewController,
               let movieId = sender as? Int {
                    movieDetailVC.movieId = movieId
                }
            }
        }
}
