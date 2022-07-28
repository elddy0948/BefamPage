import Foundation

struct ProductResponseDTO: Decodable {
  let resultCount: Int
  let results: [ProductDTO]
}

extension ProductResponseDTO {
  struct ProductDTO: Decodable {
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
}

extension ProductResponseDTO {
  func toDomain() -> ProductResponse {
    let domainResults = results.map({ $0.toDomain() })
    return ProductResponse(resultCount: resultCount,
                           results: domainResults)
  }
}

extension ProductResponseDTO.ProductDTO {
  func toDomain() -> Product {
    return Product(
      trackName: trackName,
      sellerName: sellerName,
      userRatingCount: userRatingCount,
      averageUserRating: averageUserRating,
      trackContentRating: trackContentRating,
      genres: genres,
      artworkUrl60: artworkUrl60,
      artworkUrl512: artworkUrl512,
      artworkUrl100: artworkUrl100,
      screenshotUrls: screenshotUrls,
      currentVersionReleaseDate: currentVersionReleaseDate,
      releaseNotes: releaseNotes,
      fileSizeBytes: fileSizeBytes,
      version: version,
      description: description,
      languageCodesISO2A: languageCodesISO2A
    )
  }
}
