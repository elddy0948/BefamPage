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
      completion(.failure(.cantFindProduct))
    }
  }
  
  func save(_ response: ProductResponseDTO) {
    // Have to do in background
    let cdProduct = CDProduct(context: coreDataStack.managedContext)
    
    let responseProduct = response.results[0]
    cdProduct.trackName = responseProduct.trackName
    cdProduct.sellerName = responseProduct.sellerName
    
    cdProduct.userRatingCount = Int16(responseProduct.userRatingCount)
    cdProduct.averageUserRating = responseProduct.averageUserRating
    
    cdProduct.trackContentRating = responseProduct.trackContentRating
    cdProduct.genres = responseProduct.genres
    
    cdProduct.artworkUrl60 = responseProduct.artworkUrl60
    cdProduct.artworkUrl512 = responseProduct.artworkUrl512
    cdProduct.artworkUrl100 = responseProduct.artworkUrl100
    
    cdProduct.screenshotUrls = responseProduct.screenshotUrls
    
    cdProduct.currentVersionReleaseDate = responseProduct.currentVersionReleaseDate
    cdProduct.releaseNotes = responseProduct.releaseNotes
    
    cdProduct.fileSizeBytes = responseProduct.fileSizeBytes
    cdProduct.version = responseProduct.version
    
    cdProduct.des = responseProduct.description
    cdProduct.languageCodesISO2A = responseProduct.languageCodesISO2A
    
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
