//
// Created by Qiao Zhang on 1/18/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit.UIStoryboardSegue


protocol PhotoListRouter: RouterAbleToShowImageViewCOntroller {
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
      let photoListCellItem = sender as! PhotoListCellItem
      let imageViewItem = ImageViewItem(imageViewTitle: photoListCellItem.title,
                                        imageURL: photoListCellItem.imageURL)
      showImageViewController(for: segue, item: imageViewItem)
    default:
      fatalError("Invalid segue identifier")
    }
  }

  func wireup(_ cell: PhotoListCell) {
    let presenter = ImagePresenter(output: cell)
    cell.output = ImageDataInteractor(output: presenter)
  }

}
