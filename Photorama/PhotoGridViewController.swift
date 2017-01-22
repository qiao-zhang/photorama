//
// Created by Qiao Zhang on 1/15/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoGridDataSource {
  func setPhotoItems(_ photoGridCellItems: [PhotoGridCellItem])
}

struct PhotoGridCellItem {
  let title: String
  let imageURL: URL
}

protocol PhotoGridViewControllerOutput {
  func loadInterestingPhotoGridCellItems()
  func loadRecentPhotoGridCellItems()
}

class PhotoGridViewController: UIViewController, PhotoGridPresenterOutput,
    UICollectionViewDataSource {
  @IBOutlet weak var collectionView: UICollectionView!
  var photoGridDataSource: (PhotoGridDataSource & UICollectionViewDataSource)!
  var output: PhotoGridViewControllerOutput!
  var router: PhotoGridRouter!
  
  enum State {
    case starting
    case loadingPhotoGridCellItems
    case showingPhotoGridCellItems
    case showingFailure
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
//    output.loadInterestingPhotoGridCellItems()
  }

  func showPhotoGridCells(_ photoGridCellItems: [PhotoGridCellItem]) {
    photoGridDataSource.setPhotoItems(photoGridCellItems)
    collectionView.reloadData()
  }

  func showFailure() {
    photoGridDataSource.setPhotoItems([])
    collectionView.reloadData()
  }
  
  // MARK: UICollectionViewDataSource
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(
      _ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: PhotoGridCell.identifier,
        for: indexPath) as! PhotoGridCell
    if cell.output == nil {
      router.wireup(cell)
    }
    return cell
  }
}
