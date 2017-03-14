//
// Created by Qiao Zhang on 3/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit



protocol PhotoImageView: class {
  var presenter: PhotoImageViewPresenter! { get set }
  func onFetched(_ image: UIImage)
}

protocol PhotoImageViewPresenter {
  func viewWillAppear()
}

class PhotoImageViewImp: UIViewController, PhotoImageView {
  
  var presenter: PhotoImageViewPresenter!
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var spinner: UIActivityIndicatorView!

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    state = .fetchingImage
    presenter.viewWillAppear()
  }

  func onFetched(_ image: UIImage) {
    state = .showingImage(image)
  }

  var state: State = .entry {
    didSet {
      switch state {
      case .entry:
        break
      case .fetchingImage:
        spinner.startAnimating()
        imageView.isHidden = true
      case .showingImage(let image):
        spinner.stopAnimating()
        imageView.image = image
        imageView.isHidden = false
      }
    }
  }
  
  enum State {
    case entry
    case fetchingImage
    case showingImage(UIImage)
  }
}

