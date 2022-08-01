import UIKit

final class ProductViewController: UIViewController {
  
  private let tableView = UITableView()
  private let fetchProductUseCase: FetchProductUseCase
  private let downloadImageUseCase: DownloadImageUseCase
  
  private let activityIndicator = UIActivityIndicatorView(style: .large)
  
  private var product: Product? {
    didSet {
      self.downloadTitleImage()
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
        self?.tableView.layoutIfNeeded()
      }
    }
  }
  
  private var imageForNavigationTitle: UIImage?
  
  init(
    fetchProductUseCase: FetchProductUseCase,
    downloadImageUseCase: DownloadImageUseCase
  ) {
    self.fetchProductUseCase = fetchProductUseCase
    self.downloadImageUseCase = downloadImageUseCase
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
    fetchProduct()
  }
  
  private func fetchProduct() {
    activityIndicator.startAnimating()
    fetchProductUseCase.start(
      cached: { [weak self] cachedProduct in
        self?.activityIndicator.stopAnimating()
        self?.product = cachedProduct
      }, completion: { [weak self] result in
        self?.activityIndicator.stopAnimating()
        switch result {
        case .success(let product):
          self?.product = product
        case .failure(_):
          return
        }
      })
  }
}

//MARK: - UI / Layout
extension ProductViewController {
  private func style() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .systemBackground
    
    activityIndicator.hidesWhenStopped = true
    
    //MARK: - Register Cells
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
    tableView.register(
      DescriptionCell.self,
      forCellReuseIdentifier: DescriptionCell.reuseIdentifier
    )
  }
  
  private func layout() {
    view.addSubview(tableView)
    view.addSubview(activityIndicator)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
  
  private func downloadTitleImage() {
    guard let product = product else { return }
    DispatchQueue.global(qos: .utility).async { [weak self] in
      self?.downloadImageUseCase.start(
        url: product.artworkUrl60,
        completion: { result in
          switch result {
          case .success(let data):
            self?.imageForNavigationTitle = UIImage(data: data)
          case .failure(_):
            return
          }
        })
    }
  }
}

//MARK: - UITableViewDataSource
extension ProductViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 5
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
        usecase: downloadImageUseCase,
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
      cell.configureCellData(version: product.version, versionDescription: product.releaseNotes)
      cell.delegate = self
      return cell
    case 3:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: ScreenshotCell.reuseIdentifier, for: indexPath
      ) as? ScreenshotCell else { return UITableViewCell() }
      cell.configure(with: product.screenshotUrls,
                     usecase: downloadImageUseCase)
      return cell
    case 4:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: DescriptionCell.reuseIdentifier,
        for: indexPath
      ) as? DescriptionCell else { return UITableViewCell() }
      cell.delegate = self
      cell.configureCellData(description: product.description)
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

extension ProductViewController: DescriptionCellDelegate {
  func didTappedMoreButton(_ button: UIButton, descriptionLabel: UILabel) {
    tableView.beginUpdates()
    button.isHidden = true
    descriptionLabel.numberOfLines = 0
    tableView.endUpdates()
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.section == 0 {
      createImageViewForNavigationTitle()
    }
  }
  
  private func createImageViewForNavigationTitle() {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    imageView.image = imageForNavigationTitle
    navigationItem.titleView = imageView
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      navigationItem.titleView = nil
    }
  }
}
