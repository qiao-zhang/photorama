//
// Created by Qiao Zhang on 1/18/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit.UIStoryboardSegue

protocol PhotoListRouter {
  func showImage(from photoListViewController: PhotoListViewController,
                 for photoTableViewCellItem: PhotoListCellItem)
  func prepare(for segue: UIStoryboardSegue,
               sender: Any?)
  func wireup(_ cell: PhotoListCell)
}

class PhotoListRouterImp: PhotoListRouter {
  private var identifierForShowingImageViewController: String {
    return "ShowImageViewController"
  }

  private func showImageViewController(for segue: UIStoryboardSegue,
                                       payload: Any?) {
    let imageViewController = segue.destination as! ImageViewController
    let imagePresenter = ImagePresenter(output: imageViewController)
    imageViewController.output = imagePresenter
    let photoListCellItem = payload as! PhotoListCellItem
    let imageViewItem = ImageViewItem(imageViewTitle: photoListCellItem.title,
                                      imageURL: photoListCellItem.imageURL)
    imageViewController.item = imageViewItem
  }
  
  func showImage(from photoListView: PhotoListViewController,
                 for photoListCellItem: PhotoListCellItem) {
    photoListView.performSegue(
        withIdentifier: identifierForShowingImageViewController,
        sender: photoListCellItem)
  }

  func prepare(for segue: UIStoryboardSegue,
               sender: Any?) {
    switch segue.identifier {
    case identifierForShowingImageViewController?:
      showImageViewController(for: segue, payload: sender)
    default:
      fatalError("Invalid segue identifier")
    }
  }

  func wireup(_ cell: PhotoListCell) {
    cell.output = ImageDataInteractor()
  }

}
