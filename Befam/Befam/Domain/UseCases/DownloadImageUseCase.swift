import Foundation

final class DownloadImageUseCase {
  private let repository: ImageRepository
  
  init(repository: ImageRepository) {
    self.repository = repository
  }
  
  func start(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
    repository.fetchImage(with: url, completion: { result in
      DispatchQueue.main.async {
        completion(result)
      }
    })
  }
}
