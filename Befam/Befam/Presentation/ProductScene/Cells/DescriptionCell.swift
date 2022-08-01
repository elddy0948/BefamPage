import UIKit

protocol DescriptionCellDelegate: AnyObject {
  func didTappedMoreButton(_ button: UIButton, descriptionLabel: UILabel)
}

final class DescriptionCell: UITableViewCell {
  static let reuseIdentifier = String(describing: DescriptionCell.self)
  
  private let stackView = UIStackView()
  private let descriptionLabel = UILabel()
  private let moreButton = UIButton(type: .system)
  
  weak var delegate: DescriptionCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    cellStyle()
    layout()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCellData(description: String) {
    self.descriptionLabel.text = description
  }
}

//MARK: - UI / Layout
extension DescriptionCell {
  private func cellStyle() {
    selectionStyle = .none
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    
    descriptionLabel.numberOfLines = 3
    descriptionLabel.font = .preferredFont(forTextStyle: .callout)
    
    moreButton.setTitle("더보기", for: [])
    moreButton.addTarget(self, action: #selector(didTappedMoreButton(_:)), for: .touchUpInside)
  }
  
  private func layout() {
    contentView.addSubview(stackView)
    
    stackView.addArrangedSubview(descriptionLabel)
    stackView.addArrangedSubview(moreButton)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(
        equalToSystemSpacingBelow: contentView.topAnchor,
        multiplier: 2
      ),
      stackView.leadingAnchor.constraint(
        equalToSystemSpacingAfter: contentView.leadingAnchor,
        multiplier: 2
      ),
      contentView.trailingAnchor.constraint(
        equalToSystemSpacingAfter: stackView.trailingAnchor,
        multiplier: 2
      ),
      contentView.bottomAnchor.constraint(
        equalToSystemSpacingBelow: stackView.bottomAnchor,
        multiplier: 2
      ),
    ])
  }
}

//MARK: - Actions
extension DescriptionCell {
  @objc func didTappedMoreButton(_ sender: UIButton) {
    delegate?.didTappedMoreButton(sender, descriptionLabel: self.descriptionLabel)
  }
}
