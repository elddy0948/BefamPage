import UIKit

final class ProductViewController: UIViewController {
  
  private let tableView = UITableView()
  private let fetchProductUseCase: FetchProductUseCase
  private var product: Product? {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
        self?.tableView.layoutIfNeeded()
      }
    }
  }
  
  init(
    fetchProductUseCase: FetchProductUseCase
  ) {
    self.fetchProductUseCase = fetchProductUseCase
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    style()
    layout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchProductUseCase.start(
      cached: { cachedProduct in
        self.product = cachedProduct
      }, completion: { result in
        switch result {
        case .success(let product):
          self.product = product
        case .failure(let error):
          print(error)
        }
      })
  }
}

extension ProductViewController {
  private func style() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .systemBackground
    
    tableView.register(
      ProductMainCell.self,
      forCellReuseIdentifier: ProductMainCell.reuseIdentifier
    )
    tableView.register(
      AppInfoCell.self,
      forCellReuseIdentifier: AppInfoCell.reuseIdentifier
    )
    tableView.register(
      VersionHistoryCell.self,
      forCellReuseIdentifier: VersionHistoryCell.reuseIdentifier
    )
    tableView.register(
      ScreenshotCell.self,
      forCellReuseIdentifier: ScreenshotCell.reuseIdentifier
    )
  }
  
  private func layout() {
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}

extension ProductViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let product = product else { return UITableViewCell() }
    
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: ProductMainCell.reuseIdentifier,
        for: indexPath
      ) as? ProductMainCell else { return UITableViewCell() }
      cell.configureCellData(
        imageURL: product.artworkUrl100,
        productName: product.trackName,
        sellerName: product.sellerName
      )
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: AppInfoCell.reuseIdentifier,
        for: indexPath
      ) as? AppInfoCell else { return UITableViewCell() }
      cell.configureCellData(product: product)
      return cell
    case 2:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: VersionHistoryCell.reuseIdentifier,
        for: indexPath
      ) as? VersionHistoryCell else { return UITableViewCell() }
      cell.configureCellData(version: product.version, versionDescription: product.description)
      cell.delegate = self
      return cell
    case 3:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: ScreenshotCell.reuseIdentifier, for: indexPath
      ) as? ScreenshotCell else { return UITableViewCell() }
      return cell
    default:
      break
    }
    
    return UITableViewCell()
  }
}

extension ProductViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 { return 88 }
    else if indexPath.section == 3 { return 408 }
    return UITableView.automaticDimension
  }
}

extension ProductViewController: VersionHistoryCellDelegate {
  func didTappedMoreButton(_ button: UIButton, label: UILabel) {
    tableView.beginUpdates()
    button.isHidden = true
    label.numberOfLines = 0
    tableView.endUpdates()
  }
}
