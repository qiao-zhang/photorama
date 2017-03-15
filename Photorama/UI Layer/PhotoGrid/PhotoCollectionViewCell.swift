//
// Created by Qiao Zhang on 3/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

class PhotoGridCell: UICollectionViewCell {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var spinner: UIActivityIndicatorView!

  override func awakeFromNib() {
    super.awakeFromNib()
    spinner.hidesWhenStopped = true
    update(with: nil)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    update(with: nil)
  }

  func update(with image: UIImage?) {
    if let imageToDisplay = image {
      spinner.stopAnimating()
      imageView.image = imageToDisplay
    } else {
      spinner.startAnimating()
      imageView.image = nil
    }
  }
}
