import UIKit

final class ScreenshotCollectionViewCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: ScreenshotCollectionViewCell.self)
  
  //MARK: - Views
  lazy var screenshotImageView: UIImageView = {
    let imageview = UIImageView()
    imageview.contentMode = .scaleAspectFill
    return imageview
  }()
  
  //MARK: - Properties
  private var cellImageUrl = ""
  
  //MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    cellStyle()
    layout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    screenshotImageView.image = nil
  }
  
  func downloadImage(with url: String, usecase: DownloadImageUseCase?) {
    cellImageUrl = url
    usecase?.start(url: cellImageUrl, completion: { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let data):
        if self.cellImageUrl == url {
          self.screenshotImageView.image = UIImage(data: data)
        }
      case .failure(_):
        break
      }
    })
  }
}

//MARK: - UI / Layout
extension ScreenshotCollectionViewCell {
  private func cellStyle() {
    contentView.addSubview(screenshotImageView)
    screenshotImageView.translatesAutoresizingMaskIntoConstraints = false
    
    screenshotImageView.layer.cornerRadius = 16
    screenshotImageView.clipsToBounds = true
  }
  
  private func layout() {
    NSLayoutConstraint.activate([
      screenshotImageView.topAnchor.constraint(
        equalTo: contentView.topAnchor
      ),
      screenshotImageView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor
      ),
      screenshotImageView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor
      ),
      screenshotImageView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor
      ),
    ])
  }
}
