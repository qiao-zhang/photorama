//
// Created by Qiao Zhang on 1/18/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoGridCellOutput {
  func loadImage(url: URL)
  func cancelLoadingImage()
}

class PhotoGridCell: UICollectionViewCell, ImagePresenterOutput {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  var item: PhotoGridCellItem! {
    didSet {
      output.loadImage(url: item.imageURL)
      imageView.image = nil
      spinner.startAnimating()
    }
  }
  var output: PhotoGridCellOutput!
  
  static let identifier = "PhotoGridCell"

  override func prepareForReuse() {
    super.prepareForReuse()
    output.cancelLoadingImage()
    imageView.image = nil
    spinner.stopAnimating()
  }

  func showImage(_ image: UIImage) {
    spinner.stopAnimating()
    imageView.image = image
  }
}
