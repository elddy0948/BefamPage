protocol ProductRepository {
  func fetchProduct(completion: @escaping (Result<Product, Error>) -> Void)
}
