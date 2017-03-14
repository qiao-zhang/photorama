//
// Created by Qiao Zhang on 3/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

class PhotoListFetchingCell: UITableViewCell {
  @IBOutlet var spinner: UIActivityIndicatorView!
}

class PhotoListFailureCell: UITableViewCell {
  @IBOutlet var messageLabel: UILabel!
}