import Foundation

final class FetchProductUseCase {
  private let repository: ProductRepository
  
  init(repository: ProductRepository) {
    self.repository = repository
  }
  
  func start(completion: @escaping (Result<Product, Error>) -> Void) {
    repository.fetchProduct(completion: { result in
      completion(result)
    })
  }
}
