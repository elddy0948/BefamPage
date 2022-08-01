import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  
  private let storage = CoreDataProductResponseStorage()
  lazy var repository: ProductRepository = {
    let repo = DefaultProductRepository(persistentStorage: self.storage)
    return repo
  }()
  lazy var fetchProductUseCase: FetchProductUseCase = {
    let usecase = FetchProductUseCase(repository: self.repository)
    return usecase
  }()

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    window?.backgroundColor = .systemBackground
    window?.rootViewController = ProductViewController(
      fetchProductUseCase: fetchProductUseCase
    )
    window?.makeKeyAndVisible()
  }
}

