//
// Created by Qiao Zhang on 1/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoListCellOutput {
  func loadImage(url: URL)
  func cancelLoadingImage()
}

struct PhotoListCellItem {
  let title: String
  let imageURL: URL
}

class PhotoListCell: UITableViewCell, ImagePresenterOutput {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var thumbnail: UIImageView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  var output: PhotoListCellOutput!
  
  func configure(with photoListCellItem: PhotoListCellItem) {
    titleLabel.text = photoListCellItem.title
    output.loadImage(url: photoListCellItem.imageURL)
    thumbnail.image = nil
    activityIndicatorView.startAnimating()
  }

  func showImage(_ image: UIImage) {
    activityIndicatorView.stopAnimating()
    thumbnail.image = image
  }
  
//  override func prepareForReuse() {
//    super.prepareForReuse()
//    output.cancelLoadingImage()
//    activityIndicatorView.stopAnimating()
//    thumbnail.image = nil
//  }
}
