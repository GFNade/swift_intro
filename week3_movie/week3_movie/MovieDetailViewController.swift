//
//  MovieDetailViewController.swift
//  week3_movie
//
//  Created by NhanNT on 01/07/2024.
//

import Foundation
import UIKit
import Alamofire

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var detailMovieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var addToWatchlistButton: UIButton!
    
    var movieId: Int?
    let apiKey = "3904a5223ee034d1f223645fa76fc9fc"
    let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzOTA0YTUyMjNlZTAzNGQxZjIyMzY0NWZhNzZmYzlmYyIsIm5iZiI6MTcxOTk3OTkwMC4zMTE4NDYsInN1YiI6IjY2N2QxNzMyZDY2OTFlOTkwODc5NDE1OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZIBPHX5TyYeAkg4aAfFxdGtwjMMR4mnntCwblOjalWs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movieId = movieId {
            fetchMovieDetails(movieId: movieId)
            
            detailMovieImage.layer.cornerRadius = 10;
            detailMovieImage.layer.masksToBounds = true;
            
            trailerButton.layer.cornerRadius = 20;
            trailerButton.layer.masksToBounds = true;
            
            addToWatchlistButton.layer.cornerRadius = 20;
            addToWatchlistButton.layer.borderWidth = 1;
            addToWatchlistButton.layer.borderColor = UIColor.white.cgColor;
            addToWatchlistButton.layer.masksToBounds = true;
        }
    }
    
    func fetchMovieDetails(movieId: Int) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(apiKey)&language=en-US&append_to_response=videos"
        
        AF.request(urlString).responseDecodable(of: MovieDetail.self) { response in
            switch response.result {
            case .success(let movieDetail):
                self.updateUI(with: movieDetail)
            case .failure(let error):
                print("Error fetching movie details: \(error)")
            }
        }
    }
        
    func updateUI(with movieDetail: MovieDetail) {
        // Update movie title
        movieTitleLabel.text = movieDetail.originalTitle

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
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: posterURL) {
                    DispatchQueue.main.async {
                        self.detailMovieImage.image = UIImage(data: data)
                    }
                }
            }
        }
        
        overviewLabel.text = movieDetail.overview
    }
    
    @IBAction func watchTrailerButton(_ sender: Any) {
    }
    
    
    @IBAction func addToWatchlistButton(_ sender: Any) {
        guard let movieId = movieId else { return }
            let urlString = "https://api.themoviedb.org/3/account/21351733/watchlist?"
            let parameters: [String: Any] = [
                "media_type": "movie",
                "media_id": movieId,
                "watchlist": true
            ]
            
        let headers: HTTPHeaders = [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
            
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: WatchlistResponse.self) { response in
                    switch response.result {
                    case .success(let watchlistResponse):
                        print("Status Code: \(watchlistResponse.statusCode)")
                        print("Status Message: \(watchlistResponse.statusMessage)")
                        
                    case .failure(let error):
                        print("Error adding to watchlist: \(error)")
                    }
                }
        
    }
}

struct MovieDetail: Decodable {
    let id: Int
    let originalTitle: String
    let rating: Double
    let genres: [Genre]
    let releaseDate: String
    let runtime: Int
    let posterPath: String?
    let overview: String
    
    private enum CodingKeys: String, CodingKey {
        case id, originalTitle = "original_title", rating = "vote_average", genres, releaseDate = "release_date", runtime, posterPath = "poster_path", overview = "overview"
    }
    
    struct Genre: Decodable {
        let id: Int
        let name: String
    }
    
}
