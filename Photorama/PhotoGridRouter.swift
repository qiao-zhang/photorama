//
// Created by Qiao Zhang on 1/18/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit.UIStoryboardSegue

protocol PhotoGridRouter {
  func prepare(for segue: UIStoryboardSegue, sender: Any?)
  func wireup(_ cell: PhotoGridCell)
}

class PhotoGridRouterImp: PhotoGridRouter, RouterAbleToShowImageViewCOntroller {
  
  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "ToImageViewControllerFromPhotoGridViewController"?:
      let photoGridCell = sender as! PhotoGridCell
      let photoGridCellItem = photoGridCell.item!
      let imageViewItem = ImageViewItem(imageViewTitle: photoGridCellItem.title,
                                        imageURL: photoGridCellItem.imageURL)
      showImageViewController(for: segue, item: imageViewItem)
    default:
      fatalError("Invalid segue identifier")
    }
  }
  
  func wireup(_ cell: PhotoGridCell) {
    let presenter = ImagePresenter(output: cell)
    cell.output = ImageDataInteractor(output: presenter)
  }
}
