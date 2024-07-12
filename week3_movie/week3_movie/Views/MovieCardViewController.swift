import UIKit
import Alamofire
import Hero
import RxSwift
import RxCocoa

class MovieCardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var openFavoriteButton: UIButton!
    
    var viewModel = MovieCardViewModel()
    let refreshControl = UIRefreshControl()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        navigationController?.hero.isEnabled = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupBindings()
        setupRefreshControl()
        
        fetchWatchlistAndMovies()

    }
    
    
    func setupBindings() {
        viewModel.watchlistSubject
            .subscribe(onNext: { [weak self] _ in
                self?.fetchMovies()
            })
            .disposed(by: disposeBag)
    }
    
    func setupRefreshControl() {
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        tableView.refreshControl = refreshControl
        print("setupRefreshControl called")
    }
    
    @objc func refreshMovies() {
        viewModel.currentPage = 1
        tableView.reloadData()
        
        fetchWatchlistAndMovies()
    }
    
    func fetchWatchlistAndMovies() {
        print("fetchWatchlistAndMovies called")
        viewModel.fetchWatchlist { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.fetchMovies()
                self.refreshControl.endRefreshing()
            case .failure(let error):
                print("Error fetching watchlist: \(error)")
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func fetchMovies() {
        print(viewModel.currentPage)
        viewModel.fetchMovies(page: viewModel.currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
        }
    }
}
