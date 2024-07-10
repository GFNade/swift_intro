import UIKit
import Alamofire
import Hero

class MovieCardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var openFavoriteButton: UIButton!
    
    var viewModel = MovieCardViewModel()
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        navigationController?.hero.isEnabled = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupRefreshControl()
        bindViewModel()
        viewModel.fetchWatchlist { [weak self] result in
            switch result {
            case .success:
                self?.viewModel.fetchMovies(page: self?.viewModel.currentPage ?? 1) { _ in
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Error fetching watchlist: \(error)")
            }
        }
    }
    func setupRefreshControl() {
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func refreshMovies() {
        viewModel.currentPage = 1
        viewModel.movies.removeAll()
        tableView.reloadData()
        refreshControl.beginRefreshing()
        viewModel.fetchMovies(page: viewModel.currentPage) { [weak self] _ in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func handleAddedToWatchlistNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let movieId = userInfo["movieId"] as? Int {
            if let index = viewModel.movies.firstIndex(where: { $0.id == movieId }) {
                viewModel.fetchWatchlist { [weak self] result in
                    switch result {
                    case .success:
                        self?.viewModel.movies[index].isInWatchlist = self?.viewModel.watchlist.contains(movieId) ?? false
                        DispatchQueue.main.async {
                            self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        }
                    case .failure(let error):
                        print("Error fetching watchlist: \(error)")
                    }
                }
            }
        }
    }
    
    private func bindViewModel() {
    }
}
