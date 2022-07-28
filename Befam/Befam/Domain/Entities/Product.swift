import Foundation

struct Product {
  let trackName: String
  let sellerName: String
  
  let userRatingCount: Int
  let averageUserRating: Double
  
  let trackContentRating: String
  let genres: [String]
  
  let artworkUrl60: String
  let artworkUrl512: String
  let artworkUrl100: String
  
  let screenshotUrls: [String]
  
  let currentVersionReleaseDate: String
  let releaseNotes: String
  
  let fileSizeBytes: String
  let version: String
  
  let description: String
  let languageCodesISO2A: [String]
}
