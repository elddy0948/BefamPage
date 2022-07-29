import CoreData

final class CoreDataProductResponseStorage {
  private let coreDataStack: CoreDataStack
  
  init(storage: CoreDataStack = CoreDataStack.shared) {
    coreDataStack = storage
  }
}

extension CoreDataProductResponseStorage: ProductResponseStorage {
  func fetchProduct(completion: @escaping (Result<ProductResponseDTO, StorageError>) -> Void) {
    // Have to do in background
    let request = CDProduct.fetchRequest()
    do {
      let result = try coreDataStack.managedContext.fetch(request).first
      
      guard let result = result else {
        completion(.failure(.cantFindProduct))
        return
      }
      let response = createDTOModel(with: result)
      
      completion(.success(response))
    } catch {
      print("error")
      completion(.failure(.cantFindProduct))
    }
  }
  
  func save(_ response: ProductResponseDTO) {
    // Have to do in background
    coreDataStack.saveContext()
  }
  
  private func createDTOModel(
    with result: CDProduct
  ) -> ProductResponseDTO {
    let product = ProductResponseDTO.ProductDTO(
      trackName: result.trackName, sellerName: result.sellerName,
      userRatingCount: Int(result.userRatingCount),
      averageUserRating: result.averageUserRating,
      trackContentRating: result.trackContentRating,
      genres: result.genres,
      artworkUrl60: result.artworkUrl60,
      artworkUrl512: result.artworkUrl512,
      artworkUrl100: result.artworkUrl100,
      screenshotUrls: result.screenshotUrls,
      currentVersionReleaseDate: result.currentVersionReleaseDate,
      releaseNotes: result.releaseNotes,
      fileSizeBytes: result.fileSizeBytes,
      version: result.version,
      description: result.description,
      languageCodesISO2A: result.languageCodesISO2A
    )
    
    let response = ProductResponseDTO(
      resultCount: 1,
      results: [product]
    )
    
    return response
  }
}
