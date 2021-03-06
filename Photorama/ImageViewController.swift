//
// Created by Qiao Zhang on 1/15/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol ImageViewControllerOutput {
  func loadImage(url: URL)
  func cancelLoadingImage()
}

struct ImageViewItem {
  let imageViewTitle: String
  let imageURL: URL
}

class ImageViewController: UIViewController, ImagePresenterOutput {
  @IBOutlet weak var imageView: UIImageView!
  var item: ImageViewItem!
  var output: ImageViewControllerOutput!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = item.imageViewTitle
    output.loadImage(url: item.imageURL)
    imageView.image = nil
  }

  func showImage(_ image: UIImage) {
    imageView.image = image
  }
  
  func showFailure() {
    imageView.image = nil
    imageView.backgroundColor = UIColor.darkGray
  }
}
