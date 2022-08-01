import UIKit

final class ScreenshotCell: UITableViewCell {
  static let reuseIdentifier = String(describing: ScreenshotCell.self)
  
  //MARK: - Views
  lazy var flowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.sectionInsetReference = .fromSafeArea
    return flowLayout
  }()
  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: flowLayout
    )
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()
  
  private var screenshotURLs = [String]() {
    didSet {
      collectionView.reloadData()
    }
  }
  private var usecase: DownloadImageUseCase?
  
  override init(style: UITableViewCell.CellStyle,
                reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    cellStyle()
    layout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    cellStyle()
    layout()
  }
  
  func configure(with urls: [String], usecase: DownloadImageUseCase) {
    self.screenshotURLs = urls
    self.usecase = usecase
  }
}

//MARK: - UI Setup / Layout
extension ScreenshotCell {
  private func cellStyle() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .systemBackground
    collectionView.register(
      ScreenshotCollectionViewCell.self,
      forCellWithReuseIdentifier: ScreenshotCollectionViewCell.reuseIdentifier
    )
    
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  private func layout() {
    contentView.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(
        equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1
      ),
      collectionView.leadingAnchor.constraint(
        equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2
      ),
      contentView.trailingAnchor.constraint(
        equalToSystemSpacingAfter: collectionView.trailingAnchor, multiplier: 2
      ),
      contentView.bottomAnchor.constraint(
        equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 1
      )
    ])
  }
}

//MARK: - UICollectionViewDataSource
extension ScreenshotCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return screenshotURLs.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ScreenshotCollectionViewCell.reuseIdentifier,
      for: indexPath
    ) as? ScreenshotCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let url = screenshotURLs[indexPath.item]
    cell.downloadImage(with: url, usecase: usecase)
    
    return cell
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ScreenshotCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 248, height: 392)
  }
}
