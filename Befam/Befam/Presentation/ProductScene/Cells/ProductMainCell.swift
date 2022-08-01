import UIKit

final class ProductMainCell: UITableViewCell {
  static let reuseIdentifier = String(describing: ProductMainCell.self)
  
  private let productImageView = UIImageView()
  private let labelsStackView = UIStackView()
  private let productNameLabel = UILabel()
  private let sellerNameLabel = UILabel()
  private let mockButton = UIButton()
  
  override init(style: UITableViewCell.CellStyle,
                reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    cellStyle()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCellData(
    usecase: DownloadImageUseCase,
    imageURL: String,
    productName: String,
    sellerName: String
  ) {
    productNameLabel.text = productName
    sellerNameLabel.text = sellerName
    usecase.start(url: imageURL,
                  completion: { [weak self] result in
      switch result {
      case .success(let data):
        self?.productImageView.image = UIImage(data: data)
      case .failure(_):
        break
      }
    })
  }
}

extension ProductMainCell {
  private func cellStyle() {
    selectionStyle = .none
    labelsStackView.translatesAutoresizingMaskIntoConstraints = false
    productImageView.translatesAutoresizingMaskIntoConstraints = false
    productNameLabel.translatesAutoresizingMaskIntoConstraints = false
    sellerNameLabel.translatesAutoresizingMaskIntoConstraints = false
    mockButton.translatesAutoresizingMaskIntoConstraints = false
    
    labelsStackView.axis = .vertical
    labelsStackView.distribution = .equalSpacing
    
    productImageView.layer.cornerRadius = 8
    productImageView.clipsToBounds = true
    productImageView.contentMode = .scaleAspectFit

    productNameLabel.font = .preferredFont(forTextStyle: .title2)
    productNameLabel.textColor = .label
    productNameLabel.text = "Here is Product Name!"
    productNameLabel.numberOfLines = 2
    
    sellerNameLabel.font = .preferredFont(forTextStyle: .body)
    sellerNameLabel.textColor = .secondaryLabel
    sellerNameLabel.text = "Here is Seller Name!"
    sellerNameLabel.numberOfLines = 1
  }
  
  private func layout() {
    contentView.addSubview(productImageView)
    contentView.addSubview(labelsStackView)
    
    productImageView.setContentHuggingPriority(.defaultHigh,
                                               for: .horizontal)
    productImageView.setContentHuggingPriority(.defaultHigh,
                                               for: .vertical)
    labelsStackView.setContentHuggingPriority(.defaultLow,
                                              for: .horizontal)
    
    labelsStackView.addArrangedSubview(productNameLabel)
    labelsStackView.addArrangedSubview(sellerNameLabel)
    
    NSLayoutConstraint.activate([
      productImageView.topAnchor.constraint(
        equalToSystemSpacingBelow: contentView.topAnchor,
        multiplier: 2
      ),
      productImageView.leadingAnchor.constraint(
        equalToSystemSpacingAfter: contentView.leadingAnchor,
        multiplier: 2
      ),
      contentView.bottomAnchor.constraint(
        equalToSystemSpacingBelow: productImageView.bottomAnchor,
        multiplier: 2
      ),
      productImageView.widthAnchor.constraint(
        equalToConstant: 100
      ),
      contentView.trailingAnchor.constraint(
        equalToSystemSpacingAfter: labelsStackView.trailingAnchor,
        multiplier: 2
      ),
      contentView.bottomAnchor.constraint(
        equalToSystemSpacingBelow: labelsStackView.bottomAnchor,
        multiplier: 2
      ),
      labelsStackView.leadingAnchor.constraint(
        equalToSystemSpacingAfter: productImageView.trailingAnchor,
        multiplier: 2
      ),
      labelsStackView.topAnchor.constraint(
        equalToSystemSpacingBelow: contentView.topAnchor,
        multiplier: 2
      )
    ])
  }
}
