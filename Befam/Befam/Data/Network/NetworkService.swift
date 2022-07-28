import Foundation

final class NetworkService {
  static let shared = NetworkService()
  
  private init() {}
  
  func fetchProduct(completion: @escaping (Result<ProductResponseDTO, Error>) -> Void) {
    
  }
  
  func downloadImage(url: String, completion: @escaping (Data) -> Void) {
    
  }
}
