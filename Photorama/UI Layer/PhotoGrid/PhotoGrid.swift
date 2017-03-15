//
// Created by Qiao Zhang on 3/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoGrid: class {
  var presenter: PhotoGridPresenter? { get set }
  func onFetched(_ items: [PhotoGridItem])
  func onFetched(_ image: UIImage, for item: PhotoGridItem)
}

protocol PhotoGridPresenter {
  func viewWillAppear()
  func willDisplayCell(for item: PhotoGridItem)
}

class PhotoGridImp:
  UIViewController, UICollectionViewDelegate, PhotoGrid {
  
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var spinner: UIActivityIndicatorView!
  var presenter: PhotoGridPresenter?
  let photoGridDataSource = PhotoGridDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = photoGridDataSource
    collectionView.delegate = self
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

  func onFetched(_ image: UIImage, for item: PhotoGridItem) {
    guard let index = photoGridDataSource.photoGridItems?.index(of: item) else {
      return
    }
    let indexPath = IndexPath(item: index, section: 0)
    if let cell = collectionView.cellForItem(at: indexPath) as? PhotoGridCell {
      cell.update(with: image)
    }
  }

  // MARK: UICollectionViewDelegate
  func collectionView(_ collectionView: UICollectionView,
                      willDisplay cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    let item = photoGridDataSource.photoGridItems![indexPath.row]
    presenter?.willDisplayCell(for: item)
  }

  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    let item = photoGridDataSource.photoGridItems![indexPath.row]
    Router.showPhotoImageViewFrom(self, with: item.imageURL)
  }

}
