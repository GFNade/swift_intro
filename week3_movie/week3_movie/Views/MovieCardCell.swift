//
//  MovieCardCell.swift
//  week3_movie
//
//  Created by NhanNT on 27/06/2024.
//

import Foundation
import UIKit
import Kingfisher
import Hero

class MovieCardCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var onMyWatchListLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 5
            
        posterImageView.layer.cornerRadius = 5
        posterImageView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
    func loadImage(url: String) {
        guard let url = URL(string: url) else {
        return
        }
        posterImageView.kf.setImage(with: url)
    }
        
    func loadData(movie: MovieCard) {
        self.loadImage(url: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
        DispatchQueue.main.async {
            self.movieTitleLabel.text = movie.movieTitle
            self.releaseDateLabel.text = movie.releaseDate
            self.onMyWatchListLabel.isHidden = !(movie.isInWatchlist ?? false)
        }
    }
    
    func configure(with movie: MovieCard) {
        loadImage(url: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
        movieTitleLabel.text = movie.movieTitle
        releaseDateLabel.text = movie.releaseDate
        onMyWatchListLabel.isHidden = !(movie.isInWatchlist ?? false)
    }
}
