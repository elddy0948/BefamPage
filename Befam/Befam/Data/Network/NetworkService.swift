import Foundation

final class NetworkService {
  static let shared = NetworkService()
  
  private let baseURL = "https://itunes.apple.com/kr/lookup?id=1502953604"
  
  private init() {}
  
  func fetchProduct(completion: @escaping (Result<ProductResponseDTO, Error>) -> Void) {
    guard let url = URL(string: baseURL) else { return }
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
      if let error = error {
        completion(.failure(error))
      }
      
      guard let response = response as? HTTPURLResponse,
            (200 ..< 300) ~= response.statusCode else {
        completion(.failure(NetworkError.invalidResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(NetworkError.invalidData))
        return
      }
      
      do {
        let responseDTO = try JSONDecoder().decode(ProductResponseDTO.self, from: data)
        print(responseDTO)
        completion(.success(responseDTO))
        return
      } catch {
        completion(.failure(NetworkError.decodingError))
      }
    })
    
    task.resume()
  }
  
  func downloadImage(url: String, completion: @escaping (Data) -> Void) {
    
  }
}
