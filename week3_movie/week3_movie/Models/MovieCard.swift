import Foundation

struct MovieResponse: Decodable {
    let results: [MovieCard]
}

struct MovieCard: Decodable {
    let id: Int
    let title: String
    let release_date: String
    let poster_path: String
    var isInWatchlist: Bool?
    
    var movieTitle: String { title }
    var releaseDate: String { release_date }
    var posterPath: String { poster_path }
    
    private enum CodingKeys: String, CodingKey {
            case id, title, release_date, poster_path
    }
}

struct WatchlistResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
    
    private enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct FavoritelistResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
    
    private enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
