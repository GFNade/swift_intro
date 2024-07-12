//
//  FavoriteCardViewController.swift
//  week3_movie
//
//  Created by NhanNT on 08/07/2024.
//

import Foundation
import UIKit
import Hero
import RxSwift
import RxCocoa

class FavoriteCardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var viewModel = FavoriteCardViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        navigationController?.hero.isEnabled = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupRefreshControl()
        setupBindings()
        
        viewModel.fetchFavoriteMovies { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching favorite movies: \(error)")
            }
        }

        viewModel.fetchWatchlist { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("Error fetching watchlist: \(error)")
            }
        }
    }
    
    func setupBindings() {
        viewModel.watchlistSubject
            .subscribe(onNext: { [weak self] _ in
                self?.fetchFavoriteMovies()
            })
            .disposed(by: disposeBag)
        
        viewModel.favoritelistSubject
            .subscribe(onNext: { [weak self] _ in
                self?.fetchFavoriteMovies()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    func setupRefreshControl() {
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshFavoriteMovies), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshFavoriteMovies() {
        viewModel.refreshFavoriteMovies { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print("Error refreshing favorite movies: \(error)")
                self?.refreshControl.endRefreshing()
            }
        }
    }
    func fetchFavoriteMovies() {
        viewModel.fetchFavoriteMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                print("Error fetching favorite movies: \(error)")
            }
        }
    }
}
