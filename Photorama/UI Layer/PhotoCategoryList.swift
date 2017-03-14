//
// Created by Qiao Zhang on 2/20/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoCategoryList: class {
  var categoryNames: [String]? { get set }
  var handler: PhotoCategoryListEventHandler? { get set }
}

protocol PhotoCategoryListEventHandler {
  func viewWillAppear()
}

class PhotoCategoryListImp: UIViewController, PhotoCategoryList {
  
  var handler: PhotoCategoryListEventHandler?

  @IBOutlet var tableView: UITableView!
  var categoryNames: [String]? {
    didSet { tableView.reloadData() }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Photo Categories"
    // set up table view
    tableView.dataSource = self
    tableView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    handler?.viewWillAppear()
  }
}

extension PhotoCategoryListImp: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return categoryNames?.count ?? 0
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    cell.textLabel!.text = categoryNames?[indexPath.row]
    return cell
  }
}

extension PhotoCategoryListImp: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let categoryNames = categoryNames else { return }
    Router.showPhotoListFrom(self, with: categoryNames[indexPath.row])
  }
}
