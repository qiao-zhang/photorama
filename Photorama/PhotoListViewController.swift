//
//  PhotoListViewController.swift
//  Photorama
//
//  Created by Qiao Zhang on 1/11/17.
//  Copyright © 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoListViewControllerOutput {
  func loadInterestingPhotoListCellItems()
  func loadRecentPhotoListCellItems()
}

class PhotoListViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate, PhotoListPresenterOutput {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var segmentedControl: UISegmentedControl!
  var output: PhotoListViewControllerOutput!
  var router: PhotoListRouter!
  
  enum State {
    case starting
    case loadingPhotoListCellItems
    case showingPhotoListCellItems([PhotoListCellItem])
    case showingFailure
  }
  private var state: State = .starting {
    didSet {
      tableView.reloadData()
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
      output.loadInterestingPhotoListCellItems()
    case "Recent"?:
      output.loadRecentPhotoListCellItems()
    default:
      fatalError("Invalid title for segmented control")
    }
    state = .loadingPhotoListCellItems
  }
  
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 80
    
    tableView.dataSource = self
    tableView.delegate = self
    
    loadPhotoCellItems()
  }

  // MARK: Photo list presenter output
  func showFailure() {
    state = .showingFailure
  }
  
  func showPhotoListCells(_ photoListCellItems: [PhotoListCellItem]) {
    state = .showingPhotoListCellItems(photoListCellItems)
  }


  // MARK: Table view data source
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    switch state {
    case .loadingPhotoListCellItems:
      return 1
    case .showingPhotoListCellItems(let photoListCellItems):
      return photoListCellItems.count
    case .showingFailure:
      return 1
    default:
      fatalError("\(#function) shouldn't be called here")
    }
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch state {
    case .loadingPhotoListCellItems:
      let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell",
                                               for: indexPath)
      return cell
    case .showingPhotoListCellItems(let photoCellItems):
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell",
                                               for: indexPath) as! PhotoListCell
      if cell.output == nil { router.wireup(cell) }
      let photoCellItem = photoCellItems[indexPath.row]
      cell.configure(with: photoCellItem)
      return cell
    case .showingFailure:
      let cell = tableView.dequeueReusableCell(withIdentifier: "FailureCell",
                                               for: indexPath)
      return cell
    default:
      fatalError("\(#function) shouldn't be called here")
    }
  }
  
  // MARK: Table view delegate
  func tableView(_ tableView: UITableView,
                 willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    switch state {
    case .showingPhotoListCellItems:
      return indexPath
    case .starting:
      fatalError("\(#function) shouldn't be called here")
    default:
      return nil
    }
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch state {
    case .showingPhotoListCellItems(let items):
      router.showImage(from: self, for: items[indexPath.row])
    default:
      break
    }
  }

//  func tableView(_ tableView: UITableView,
//                 didEndDisplaying cell: UITableViewCell,
//                 forRowAt indexPath: IndexPath) {
//    guard let cell = cell as? PhotoListCell else { return }
//    cell.output.cancelLoadingImage()
//  }

  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    router.prepare(for: segue, sender: sender)
  }
}
