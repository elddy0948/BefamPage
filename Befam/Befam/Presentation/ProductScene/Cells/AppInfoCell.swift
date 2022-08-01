import UIKit

final class AppInfoCell: UITableViewCell {
  static let reuseIdentifier = String(describing: AppInfoCell.self)
  
  private lazy var flowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    return flowLayout
  }()
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero, collectionViewLayout: self.flowLayout
    )
    return collectionView
  }()
  
  private var product: Product?
  
  override init(style: UITableViewCell.CellStyle,
                reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    cellStyle()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("")
  }
  
  func configureCellData(product: Product) {
    self.product = product
  }
}

extension AppInfoCell {
  private func cellStyle() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(
      AppInfoCollectionViewCell.self,
      forCellWithReuseIdentifier: AppInfoCollectionViewCell.reuseIdentifier
    )
    collectionView.backgroundColor = .systemBackground
    collectionView.showsHorizontalScrollIndicator = false

    collectionView.dataSource = self
    collectionView.delegate = self
  }
  private func layout() {
    contentView.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
    ])
  }
}

extension AppInfoCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: AppInfoCollectionViewCell.reuseIdentifier,
      for: indexPath) as? AppInfoCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    guard let product = product else { return UICollectionViewCell() }
    
    switch indexPath.row {
    case 0:
      cell.configureCell(
        topTitle: "\(product.userRatingCount)개의 평가",
        imageName: nil,
        middleContent: String(format: "%.1f", product.averageUserRating),
        bottomContent: "평점"
      )
    case 1:
      cell.configureCell(
        topTitle: "연령",
        imageName: nil,
        middleContent: product.trackContentRating,
        bottomContent: "세"
      )
    case 2:
      cell.configureCell(
        topTitle: "카테고리",
        imageName: "message.fill",
        middleContent: nil,
        bottomContent: product.genres[0]
      )
    case 3:
      cell.configureCell(
        topTitle: "개발자",
        imageName: "person.crop.square",
        middleContent: nil,
        bottomContent: product.sellerName
      )
    case 4:
      cell.configureCell(
        topTitle: "언어",
        imageName: nil,
        middleContent: product.languageCodesISO2A[1],
        bottomContent: "+\(product.languageCodesISO2A.count - 1)개의 언어"
      )
    default:
      break
    }
    
    collectionView.setNeedsLayout()
    return cell
  }
}

extension AppInfoCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 88, height: 72)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
