//
// Created by Qiao Zhang on 1/15/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation
import UIKit


class PhotoramaViewController: UITableViewController {
  var router: PhotoramaRouter!
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    router.prepare(for: segue, sender: sender)
  }
}
