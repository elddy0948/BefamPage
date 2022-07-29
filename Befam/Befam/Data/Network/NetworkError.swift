import Foundation

enum NetworkError: Error {
  case invalidURL
  case invalidData
  case invalidResponse
  case decodingError
  case unknown
}
