//
// Created by Qiao Zhang on 1/15/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation
import UIKit.UIStoryboardSegue

enum ViewControllerIdentifiers: String {
  case imageViewController = "ImageViewController"
}

class Router {
  static let shared = Router()  
  private init() {}
}

extension Router: PhotoListViewControllerRouter {
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
               from _: PhotoListViewController,
               sender: Any?) {
    switch segue.identifier {
    case identifierForShowingImageViewController?:
      showImageViewController(for: segue, payload: sender)
    default:
      fatalError("Invalid segue identifier")
    }
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
}

extension Router: PhotoramaViewRouter {
  func prepare(for segue: UIStoryboardSegue,
               from _: PhotoramaViewController,
               sender: Any?) {
    switch segue.destination {
    case is PhotoListViewController:
      let photoListView = segue.destination as! PhotoListViewController
      let photoListPresenter = PhotoListPresenter(output: photoListView)
      let photosInteractor = PhotosInteractor(output: photoListPresenter)
      photoListView.output = photosInteractor
      photoListView.router = Router.shared
    default:
      break
    }
  }
}
