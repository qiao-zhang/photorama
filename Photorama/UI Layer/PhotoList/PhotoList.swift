//
// Created by Qiao Zhang on 2/20/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

fileprivate enum PhotoListState {
  case entry
  case fetchingPhotoListItems
  case showingPhotoListItems([PhotoListItem])
  case showingFailure(String)
}

protocol PhotoList: class {
  var presenter: PhotoListPresenter? { get set }
  func onFetched(_ photoListItems: [PhotoListItem])
  func onFetchingFailed(with message: String)
  func changeTitle(to title: String)
}

protocol PhotoListPresenter {
  func viewWillAppear()
  func refreshButtonTapped()
}

class PhotoListImp: UIViewController, PhotoList {
  
  fileprivate var state: PhotoListState = .entry {
    didSet { tableView.reloadData() }
  }
  var presenter: PhotoListPresenter?
  @IBOutlet var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    state = .fetchingPhotoListItems
    presenter?.viewWillAppear()
  }

  @IBAction func refreshButtonTapped() {
    presenter?.refreshButtonTapped()
  }

  func onFetched(_ photoListItems: [PhotoListItem]) {
    state = .showingPhotoListItems(photoListItems)
  }

  func onFetchingFailed(with message: String) {
    state = .showingFailure(message)
  }

  func changeTitle(to title: String) {
    navigationItem.title = title
  }

}

extension PhotoListImp: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    switch state {
    case .fetchingPhotoListItems, .showingFailure:
      return 1
    case .showingPhotoListItems(let items):
      return items.count
    default:
      fatalError("invalid state in \(#function)")
    }
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch state {
    case .showingPhotoListItems(let items):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "PhotoListCell", for: indexPath)
      let item = items[indexPath.row]
      cell.textLabel?.text = item.title
      cell.detailTextLabel?.text = item.dateTaken
      return cell
    case .fetchingPhotoListItems:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "PhotoListFetchingCell",
        for: indexPath) as! PhotoListFetchingCell
      cell.spinner.startAnimating()
      return cell
    case .showingFailure(let message):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "PhotoListFailureCell",
        for: indexPath) as! PhotoListFailureCell
      cell.messageLabel.text = message
      return cell
    default:
      fatalError("invalid state in \(#function)")
    }
  }
}

extension PhotoListImp: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    guard case .showingPhotoListItems = state else {
      return nil
    }
    return indexPath
  }


  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    guard case .showingPhotoListItems(let items) = state else {
      fatalError("invalid state in \(#function)")
    }
    tableView.deselectRow(at: indexPath, animated: true)
    let imageURL = items[indexPath.row].imageURL
    Router.showPhotoImageViewFrom(self, with: imageURL)
  }
}