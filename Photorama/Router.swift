//
// Created by Qiao Zhang on 1/15/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation
import UIKit.UIStoryboardSegue

enum ViewControllerIdentifiers: String {
  case imageView = "ImageView"
}

class Router {
  static let shared = Router()  
  private init() {}
}

extension Router: PhotoListViewRouter {
  private var identifierForShowingImageView: String {
    return "ShowImageView"
  }
  
  func showImage(from photoListView: PhotoListView,
                 `for` photoCellItem: PhotoCellItem) {
    photoListView.performSegue(withIdentifier: identifierForShowingImageView,
                               sender: photoCellItem)
  }
  
  func prepare(for segue: UIStoryboardSegue,
               from source: PhotoListView,
               with sender: Any?) {
    switch segue.identifier {
    case identifierForShowingImageView?:
      let imageView = segue.destination as! ImageView
      let imagePresenter = ImagePresenter(output: imageView)
      imageView.output = imagePresenter
//      imageView.router = Router.shared
      let photoCellItem = sender as! PhotoCellItem
      let imageViewItem = ImageViewItem(imageViewTitle: photoCellItem.title,
                                        imageURL: photoCellItem.remoteURL)
      imageView.item = imageViewItem
    default:
      break
    }
  }
}
