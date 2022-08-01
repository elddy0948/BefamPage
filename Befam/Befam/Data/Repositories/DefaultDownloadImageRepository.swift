import Foundation

final class DefaultDownloadImageRepository: ImageRepository {
  private let cache = NSCache<NSString, NSData>()
  
  func fetchImage(with url: String, completion: @escaping (Result<Data, Error>) -> Void) {
    let nsString = NSString(string: url)
    
    if let nsData = cache.object(forKey: nsString) {
      let data = Data(referencing: nsData)
      completion(.success(data))
      return
    }
    
    NetworkService.shared.downloadImage(url: url, completion: { data in
      let nsData = NSData(data: data)
      self.cache.setObject(nsData, forKey: nsString)
      DispatchQueue.main.async {
        completion(.success(data))
      }
    })
  }
}
