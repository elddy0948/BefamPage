import Foundation

final class DefaultProductRepository: ProductRepository {
  
  private let persistentStorage: ProductResponseStorage
  
  init(persistentStorage: ProductResponseStorage) {
    self.persistentStorage = persistentStorage
  }
  
  func fetchProduct(cached: @escaping (Product) -> Void, completion: @escaping (Result<Product, Error>) -> Void) {
  }
}
