//
// Created by Qiao Zhang on 1/22/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit.UIStoryboardSegue

protocol RouterAbleToShowImageViewCOntroller {
  func showImageViewController(for segue: UIStoryboardSegue,
                               item: ImageViewItem)
}

extension RouterAbleToShowImageViewCOntroller {
  func showImageViewController(`for` segue: UIStoryboardSegue,
                               item: ImageViewItem) {
    let imageViewController = segue.destination as! ImageViewController
    let imagePresenter = ImagePresenter(output: imageViewController)
    let imageDataInteractor = ImageDataInteractor(output: imagePresenter)
    imageViewController.output = imageDataInteractor
    imageViewController.item = item
  }
}
