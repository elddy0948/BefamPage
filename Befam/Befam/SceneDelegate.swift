import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  
  private let storage = CoreDataProductResponseStorage()
  lazy var repository: ProductRepository = {
    let repo = DefaultProductRepository(persistentStorage: self.storage)
    return repo
  }()
  lazy var imageRepository: ImageRepository = {
    let repo = DefaultDownloadImageRepository()
    return repo
  }()
  lazy var fetchProductUseCase: FetchProductUseCase = {
    let usecase = FetchProductUseCase(repository: self.repository)
    return usecase
  }()
  lazy var downloadImageUseCase: DownloadImageUseCase = {
    let usecase = DownloadImageUseCase(repository: self.imageRepository)
    return usecase
  }()

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    window?.backgroundColor = .systemBackground
    let viewController = ProductViewController(
      fetchProductUseCase: fetchProductUseCase,
      downloadImageUseCase: downloadImageUseCase
    )
    window?.rootViewController = UINavigationController(rootViewController: viewController)
    window?.makeKeyAndVisible()
  }
}

