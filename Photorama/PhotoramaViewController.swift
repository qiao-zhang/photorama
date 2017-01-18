//
// Created by Qiao Zhang on 1/15/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoramaViewRouter: class {
  func prepare(for segue: UIStoryboardSegue,
               from _: PhotoramaViewController,
               sender: Any?)
}

class PhotoramaViewController: UITableViewController {
  var router: PhotoramaViewRouter!
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    router.prepare(for: segue, from: self, sender: sender)
  }
}
