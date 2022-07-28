protocol ProductRepository {
  func fetchProduct(
    cached: @escaping (Product) -> Void,
    completion: @escaping (Result<Product, Error>) -> Void)
}
