import Foundation

protocol ImageRepository {
  func fetchImage(with url: String,
                  completion: @escaping (Result<Data, Error>) -> Void)
}
