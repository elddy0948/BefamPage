import Foundation

final class DefaultProductRepository: ProductRepository {
  
  private let persistentStorage: ProductResponseStorage
  
  init(persistentStorage: ProductResponseStorage) {
    self.persistentStorage = persistentStorage
  }
  
  func fetchProduct(cached: @escaping (Product) -> Void,
                    completion: @escaping (Result<Product, Error>) -> Void) {
    persistentStorage.fetchProduct(completion: { result in
      switch result {
      case .success(let responseDTO):
        cached(responseDTO.toDomain().results[0])
      default:
        break
      }
      
      //Fetch from Network
      NetworkService.shared.fetchProduct(completion: { result in
        switch result {
        case .success(let responseDTO):
          self.persistentStorage.save(responseDTO)
          DispatchQueue.main.async {
            completion(.success(responseDTO.toDomain().results[0]))
          }
        case .failure(let error):
          completion(.failure(error))
        }
      })
    })
  }
}
