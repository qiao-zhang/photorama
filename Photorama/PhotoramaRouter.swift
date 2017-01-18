//
// Created by Qiao Zhang on 1/18/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit.UIStoryboardSegue

protocol PhotoramaRouter {
  func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class PhotoramaRouterImp: PhotoramaRouter {
  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case is PhotoListViewController:
      let photoListVC = segue.destination as! PhotoListViewController
      let photoListPresenter = PhotoListPresenter(output: photoListVC)
      let photosInteractor = PhotosInteractor(output: photoListPresenter)
      photoListVC.output = photosInteractor
      photoListVC.router = PhotoListRouterImp()
    case is PhotoGridViewController:
      let photoGridVC = segue.destination as! PhotoGridViewController
      let photoGridPresenter = PhotoGridPresenter(output: photoGridVC)
      let photosInteractor = PhotosInteractor(output: photoGridPresenter)
      photoGridVC.output = photosInteractor
      photoGridVC.router = PhotoGridRouterImp()
    default:
      break
    }
  }
}