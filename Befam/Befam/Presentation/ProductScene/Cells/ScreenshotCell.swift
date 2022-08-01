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
  
  private var thumbnailImagesUrls = [String]() {
    didSet {
      collectionView.reloadData()
    }
  }
  
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
  
//  func configure(with urls: [String]) {
//    self.thumbnailImagesUrls = urls
//  }
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
        equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1
      ),
      contentView.trailingAnchor.constraint(
        equalToSystemSpacingAfter: collectionView.trailingAnchor, multiplier: 1
      ),
      contentView.bottomAnchor.constraint(
        equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 1
      )
    ])
  }
}

extension ScreenshotCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ScreenshotCollectionViewCell.reuseIdentifier,
      for: indexPath
    ) as? ScreenshotCollectionViewCell else {
      return UICollectionViewCell()
    }
    
//    let url = thumbnailImagesUrls[indexPath.item]
//    cell.downloadImage(with: url)
    
    return cell
  }
}

extension ScreenshotCell: UICollectionViewDelegate { }

extension ScreenshotCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width / 1.5, height: 392)
  }
}
