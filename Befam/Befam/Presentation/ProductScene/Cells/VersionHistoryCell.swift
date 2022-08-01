import UIKit

protocol VersionHistoryCellDelegate: AnyObject {
  func didTappedMoreButton(_ button: UIButton, label: UILabel)
}

final class VersionHistoryCell: UITableViewCell {
  static let reuseIdentifier = String(describing: VersionHistoryCell.self)
  
  private let stackView = UIStackView()
  private let titleLabel = UILabel()
  private let versionLabel = UILabel()
  private let versionDescriptionLabel = UILabel()
  private let moreButton = UIButton(type: .system)
  
  weak var delegate: VersionHistoryCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    cellStyle()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCellData(version: String, versionDescription: String) {
    self.versionLabel.text = "버전 : " + version
    self.versionDescriptionLabel.text = versionDescription
  }
}

extension VersionHistoryCell {
  private func cellStyle() {
    selectionStyle = .none
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 16
    
    titleLabel.font = .preferredFont(forTextStyle: .title1)
    titleLabel.text = "새로운 기능"
    
    versionLabel.font = .preferredFont(forTextStyle: .caption1)
    versionLabel.textColor = .secondaryLabel
    
    versionDescriptionLabel.font = .preferredFont(forTextStyle: .caption1)
    versionDescriptionLabel.numberOfLines = 2
    
    moreButton.setTitle("더보기", for: [])
    moreButton.setTitleColor(.link, for: [])
    moreButton.addTarget(self, action: #selector(didTappedMoreButton(_:)), for: .touchUpInside)
  }
  
  private func layout() {
    contentView.addSubview(stackView)
    
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(versionLabel)
    stackView.addArrangedSubview(versionDescriptionLabel)
    stackView.addArrangedSubview(moreButton)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(
        equalToSystemSpacingBelow: contentView.topAnchor,
        multiplier: 1
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
        multiplier: 1
      )
    ])
  }
}

extension VersionHistoryCell {
  @objc func didTappedMoreButton(_ sender: UIButton) {
    delegate?.didTappedMoreButton(sender, label: self.versionDescriptionLabel)
  }
}
