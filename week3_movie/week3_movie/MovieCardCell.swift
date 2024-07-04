//
//  MovieCardCell.swift
//  week3_movie
//
//  Created by NhanNT on 27/06/2024.
//

import Foundation
import UIKit

class MovieCardCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var onMyWatchListLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 5
        posterImageView.clipsToBounds = true
        onMyWatchListLabel.isHidden = true
                
        cardView.layer.cornerRadius = 8
        
        movieTitleLabel.numberOfLines = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadImage(url: String) {
            guard let url = URL(string: url) else {
                return
            }
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
    func loadData(movie: MovieCard) {	
        self.movieTitleLabel.text = movie.movieTitle
        self.releaseDateLabel.text = movie.releaseDate
        self.loadImage(url: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
        self.onMyWatchListLabel.isHidden = !(movie.isInWatchlist ?? true)
    }
}
