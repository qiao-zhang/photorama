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
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  var photoGridDataSource: (PhotoGridDataSource & UICollectionViewDataSource)!
  var output: PhotoGridViewControllerOutput!
  var router: PhotoGridRouter!
  
  enum State {
    case starting
    case loadingPhotoGridCellItems
    case showingPhotoGridCellItems([PhotoGridCellItem])
    case showingFailure
  }
  private var state: State = .starting {
    didSet {
      collectionView.reloadData()
    }
  }
  
  @IBAction func segmentedControlChanged() {
    loadPhotoCellItems()
  }
  
  private func loadPhotoCellItems() {
    let index = segmentedControl.selectedSegmentIndex
    let categoryString = segmentedControl.titleForSegment(at: index)
    switch categoryString {
    case "Interesting"?:
      output.loadInterestingPhotoGridCellItems()
    case "Recent"?:
      output.loadRecentPhotoGridCellItems()
    default:
      fatalError("Invalid title for segmented control")
    }
    state = .loadingPhotoGridCellItems
  }

  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    loadPhotoCellItems()
  }

  func showPhotoGridCells(_ photoGridCellItems: [PhotoGridCellItem]) {
//    photoGridDataSource.setPhotoItems(photoGridCellItems)
    state = .showingPhotoGridCellItems(photoGridCellItems)
  }

  func showFailure() {
//    photoGridDataSource.setPhotoItems([])
    state = .showingFailure
  }
  
  // MARK: UICollectionViewDataSource
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    switch state {
    case .showingPhotoGridCellItems(let items):
      return items.count
    case .starting:
      fatalError("\(#function) shouldn't be called here")
    default:
      return 0
    }
  }

  func collectionView(
      _ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard case .showingPhotoGridCellItems(let items) = state else {
      fatalError("\(#function) shouldn't be called here")
    }
    let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: PhotoGridCell.identifier,
        for: indexPath) as! PhotoGridCell
    if cell.output == nil {
      router.wireup(cell)
    }
    cell.item = items[indexPath.row]
    return cell
  }
  
  // MARK: Navigation
  override func prepare(`for` segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    router.prepare(for: segue, sender: sender)
  }
}
