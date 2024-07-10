//
//  MovieResponse.swift
//  week3_movie
//
//  Created by NhanNT on 09/07/2024.
//

import Foundation

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
