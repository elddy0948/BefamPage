import Foundation

final class FetchProductUseCase {
  private let repository: ProductRepository
  
  init(repository: ProductRepository) {
    self.repository = repository
  }
  
  func start(cached: @escaping (Product) -> Void,
             completion: @escaping (Result<Product, Error>) -> Void) {
    repository.fetchProduct(cached: cached, completion: { result in
      completion(result)
    })
  }
}
