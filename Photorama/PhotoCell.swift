//
// Created by Qiao Zhang on 1/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoCellOutput {
  func loadImage(url: URL)
}

class PhotoCell: UITableViewCell, PhotoCellPresenterOutput {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var thumbnail: UIImageView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  var output: PhotoCellOutput!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    output = PhotoCellPresenter(output: self)
  }

  func configure(with photoCellItem: PhotoCellItem) {
    titleLabel.text = photoCellItem.title
    output.loadImage(url: photoCellItem.remoteURL)
    thumbnail.image = nil
    activityIndicatorView.isHidden = false
    activityIndicatorView.startAnimating()
  }

  func showImage(_ image: UIImage) {
    activityIndicatorView.isHidden = true
    thumbnail.image = image
  }

  func showFailure() {
    thumbnail.image = nil
    thumbnail.backgroundColor = UIColor.darkGray
    activityIndicatorView.isHidden = true
  }

}
