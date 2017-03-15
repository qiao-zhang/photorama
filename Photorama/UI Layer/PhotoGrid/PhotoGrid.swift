//
// Created by Qiao Zhang on 3/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoGrid: class {
  var presenter: PhotoGridPresenter? { get set }
  func onFetched(_ items: [PhotoGridItem])
}

protocol PhotoGridPresenter {
  func viewWillAppear()
}

class PhotoGridImp: UIViewController, PhotoGrid {
  
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var spinner: UIActivityIndicatorView!
  var presenter: PhotoGridPresenter?
  let photoGridDataSource = PhotoGridDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = photoGridDataSource
    spinner.hidesWhenStopped = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    spinner.startAnimating()
    collectionView.isHidden = true
    presenter?.viewWillAppear()
  }

  func onFetched(_ items: [PhotoGridItem]) {
    photoGridDataSource.photoGridItems = items
    spinner.stopAnimating()
    collectionView.isHidden = false
    collectionView.reloadData()
  }

}
