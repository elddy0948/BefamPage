protocol ProductResponseStorage {
  func fetchProduct(completion: @escaping (Result<ProductResponseDTO, Error>) -> Void)
  func save(_ response: ProductResponseDTO)
}
