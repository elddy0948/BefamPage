import UIKit

final class AppInfoCollectionViewCell: UICollectionViewCell {
  static let reuseIdentifier = String(
    describing: AppInfoCollectionViewCell.self
  )
  
  private let stackView = UIStackView()
  private let topLabel = UILabel()
  private lazy var middleLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.textColor = .secondaryLabel
    return label
  }()
  private lazy var middleImageView = UIImageView()
  private lazy var bottomLabel = UILabel()
  private lazy var bottomImageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    cellStyle()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("")
  }
  
  func configureCell(
    topTitle: String, imageName: String?, middleContent: String?,
    bottomContent: String
  ) {
    topLabel.text = topTitle
    topLabel.font = .preferredFont(forTextStyle: .caption1)
    stackView.addArrangedSubview(topLabel)
    if let imageName = imageName {
      middleImageView.image = UIImage(systemName: imageName)
      middleImageView.tintColor = .secondaryLabel
      stackView.addArrangedSubview(middleImageView)
    } else if let middleContent = middleContent {
      middleLabel.text = middleContent
      stackView.addArrangedSubview(middleLabel)
    }
    
    bottomLabel.text = bottomContent
    bottomLabel.font = .preferredFont(forTextStyle: .footnote)
    stackView.addArrangedSubview(bottomLabel)
    
    contentView.layoutIfNeeded()
  }
}

extension AppInfoCollectionViewCell {
  private func cellStyle() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.alignment = .center
    stackView.backgroundColor = .systemBackground
  }
  
  private func layout() {
    contentView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
}
