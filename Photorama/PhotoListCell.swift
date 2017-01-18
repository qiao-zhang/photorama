//
// Created by Qiao Zhang on 1/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoListCellOutput {
  func loadImage(url: URL)
}

struct PhotoListCellItem {
  let title: String
  let imageURL: URL
}

class PhotoListCell: UITableViewCell, PhotoListCellPresenterOutput {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var thumbnail: UIImageView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  var output: PhotoListCellOutput!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    output = PhotoListCellPresenter(output: self)
  }

  func configure(with photoTableViewCellItem: PhotoListCellItem) {
    titleLabel.text = photoTableViewCellItem.title
    output.loadImage(url: photoTableViewCellItem.imageURL)
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
