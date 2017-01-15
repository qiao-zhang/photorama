//
//  PhotoListView.swift
//  Photorama
//
//  Created by Qiao Zhang on 1/11/17.
//  Copyright © 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoListViewOutput {
  func loadPhotoCellItems(category: PhotoCellItemCategory)
}

protocol PhotoListViewRouter {
  func showImage(from photoListView: PhotoListView,
                 for photoCellItem: PhotoCellItem)
  func prepare(for segue: UIStoryboardSegue,
               from source: PhotoListView,
               with sender: Any?)
}

class PhotoListView: UIViewController, UITableViewDataSource,
    UITableViewDelegate, PhotoListPresenterOutput {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var segmentedControl: UISegmentedControl!
  var output: PhotoListViewOutput!
  var router: PhotoListViewRouter!
  
  enum State {
    case starting
    case loadingPhotoItems
    case showingPhotoCells([PhotoCellItem])
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
    let title = segmentedControl.titleForSegment(at: index)!
    let category = PhotoCellItemCategory(rawValue: title)!
    state = .loadingPhotoItems
    output.loadPhotoCellItems(category: category)
  }
  
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // set up table view
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
  
  func showPhotoCells(_ photoCellItems: [PhotoCellItem]) {
    state = .showingPhotoCells(photoCellItems)
  }

  // MARK: Table view data source
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    switch state {
    case .loadingPhotoItems:
      return 1
    case .showingPhotoCells(let photoCellItems):
      return photoCellItems.count
    case .showingFailure:
      return 1
    default:
      fatalError("\(#function) shouldn't be called here")
    }
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch state {
    case .loadingPhotoItems:
      let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell",
                                               for: indexPath)
      return cell
    case .showingPhotoCells(let photoCellItems):
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell",
                                               for: indexPath) as! PhotoCell
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
    case .showingPhotoCells:
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
    case .showingPhotoCells(let items):
      router.showImage(from: self, for: items[indexPath.row])
    default:
      break
    }
  }
  
  // MARK: Navigation
  override func prepare(`for` segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    router.prepare(for: segue, from: self, with: sender)
  }
}
