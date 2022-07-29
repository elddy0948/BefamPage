import UIKit

class ViewController: UIViewController {
  
  let coreDataRepository = CoreDataProductResponseStorage()
  
  lazy var productUseCase: FetchProductUseCase = {
    let usecase = FetchProductUseCase(repository: self.defaultProductRepository)
    return usecase
  }()
  
  lazy var defaultProductRepository: DefaultProductRepository = {
    let repository = DefaultProductRepository(persistentStorage: self.coreDataRepository)
    return repository
  }()
  
  private var currentProduct: Product?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBlue
    
    productUseCase.start(cached: { product in
      print("🟢Cached : \(product)")
      self.currentProduct = product
    }, completion: { result in
      switch result {
      case .success(let product):
        print(product)
      case .failure(let error):
        print(error)
      }
    })
  }


}

