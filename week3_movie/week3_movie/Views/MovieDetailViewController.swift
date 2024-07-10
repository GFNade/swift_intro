//
//  MovieDetailViewController.swift
//  week3_movie
//
//  Created by NhanNT on 01/07/2024.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher
import Hero
import Cosmos
import TinyConstraints
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var detailMovieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var ratingStarView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var addToWatchlistButton: UIButton!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    
    var movieId: Int?
    var viewModel = MovieDetailViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true

        handleChangeButton(viewModel.isOnWatchlist)
        if let movieId = movieId {
            fetchMovieDetails(movieId: movieId)
            detailMovieImage.hero.id = "poster_\(movieId)"
            navigationController?.hero.isEnabled = true
            
            detailMovieImage.layer.cornerRadius = 10;
            detailMovieImage.layer.masksToBounds = true;
            
            trailerButton.layer.cornerRadius = 20;
            trailerButton.layer.masksToBounds = true;
            
            addToWatchlistButton.layer.cornerRadius = 20;
            addToWatchlistButton.layer.borderWidth = 1;
            addToWatchlistButton.layer.borderColor = UIColor.white.cgColor;
            addToWatchlistButton.layer.masksToBounds = true;
        }
        fetchFavoritelist()
    }
    
    
    
    func fetchFavoritelist() {
        viewModel.fetchFavoriteList { [weak self] result in
            switch result {
            case .success(let favoriteIds):
                self?.viewModel.favoritelist = favoriteIds
                if let movieId = self?.movieId {
                    self?.viewModel.isInFavoriteList = self?.viewModel.favoritelist.contains(movieId) ?? false
                    self?.handleChangeFavoriteButton(self?.viewModel.isInFavoriteList)
                }
            case .failure(let error):
                print("Error fetching favorite: \(error)")
            }
        }
    }
    
    func fetchMovieDetails(movieId: Int) {
        viewModel.fetchMovieDetails(movieId: movieId) { [weak self] result in
            switch result {
            case .success(let movieDetail):
                self?.updateUI(with: movieDetail)
            case .failure(let error):
                print("Error fetching movie details: \(error)")
            }
        }
    }
        
    func updateUI(with movieDetail: MovieDetail) {
        // Update movie title
        movieTitleLabel.text = movieDetail.originalTitle
        
        // Update rating star label
        lazy var cosmosView: CosmosView = {
            let view = CosmosView()
            view.settings.updateOnTouch = false
            view.settings.totalStars = 5
            view.settings.fillMode = .precise
            view.rating = movieDetail.rating/2
            return view
        } ()
        ratingStarView.addSubview(cosmosView)

        // Update rating label with bold rating value
        let ratingText = NSMutableAttributedString(string: "Rating: ")
        let boldRating = NSAttributedString(string: "\(movieDetail.rating)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: ratingLabel.font.pointSize)])
        ratingText.append(boldRating)
        let ratingText2 = NSMutableAttributedString(string: "/10")
        ratingText.append(ratingText2)
        ratingLabel.attributedText = ratingText

        // Update genre label with bold genres
        let genreText = NSMutableAttributedString(string: "Genres: ")
        let boldGenres = NSAttributedString(string: movieDetail.genres.map { $0.name }.joined(separator: ", "), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: genreLabel.font.pointSize)])
        genreText.append(boldGenres)
        genreLabel.attributedText = genreText

        // Update release date label with bold release date
        let releaseDateText = NSMutableAttributedString(string: "Release Date: ")
        let boldReleaseDate = NSAttributedString(string: movieDetail.releaseDate, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: releaseDateLabel.font.pointSize)])
        releaseDateText.append(boldReleaseDate)
        releaseDateLabel.attributedText = releaseDateText

        // Update duration label with bold runtime
        let durationText = NSMutableAttributedString(string: "Duration: ")
        let boldDuration = NSAttributedString(string: "\(movieDetail.runtime) min", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: durationLabel.font.pointSize)])
        durationText.append(boldDuration)
        durationLabel.attributedText = durationText

        // Update movie poster
        if let posterPath = movieDetail.posterPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")!
                detailMovieImage.kf.setImage(with: posterURL)
        }
        
        
        overviewLabel.text = movieDetail.overview
    }
    func handleChangeButton(_ isOnWatchlist: Bool?) {
        if (isOnWatchlist == true) {
            addToWatchlistButton.setTitle("Remove", for: .normal)
        } else {
            addToWatchlistButton.setTitle("Add to Watchlist", for: .normal)
        }
    }
    
    func handleChangeFavoriteButton(_ isInFavoriteList: Bool?) {
        if (isInFavoriteList == true) {
            addToFavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            addToFavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @IBAction func watchTrailerButton(_ sender: Any) {
    }
    
    
    @IBAction func addToWatchlistButton(_ sender: Any) {
        guard let movieId = movieId else { return }
        viewModel.addToWatchlist(movieId: movieId, isOnWatchlist: viewModel.isOnWatchlist) { [weak self] result in
            switch result {
            case .success(let watchlistResponse):
                self?.viewModel.isOnWatchlist.toggle()
                self?.handleChangeButton(self?.viewModel.isOnWatchlist)
                print("Status Code: \(watchlistResponse.statusCode)")
                print("Status Message: \(watchlistResponse.statusMessage)")
            case .failure(let error):
                print("Error adding to watchlist: \(error)")
            }
        }
    }
    
    
    @IBAction func addToFavourite(_ sender: Any) {
        guard let movieId = movieId else { return }
        viewModel.addToFavoriteList(movieId: movieId, isInFavoriteList: viewModel.isInFavoriteList) { [weak self] result in
            switch result {
            case .success(let favoritelistResponse):
                self?.viewModel.isInFavoriteList.toggle()
                self?.handleChangeFavoriteButton(self?.viewModel.isInFavoriteList)
                print("Status Code: \(favoritelistResponse.statusCode)")
                print("Status Message: \(favoritelistResponse.statusMessage)")
            case .failure(let error):
                print("Error adding to favoritelist: \(error)")
            }
        }
    }
}
