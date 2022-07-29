protocol ProductResponseStorage {
  func fetchProduct(completion: @escaping (Result<ProductResponseDTO, StorageError>) -> Void)
  func save(_ response: ProductResponseDTO)
}
