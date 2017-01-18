//
// Created by Qiao Zhang on 1/18/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol PhotoGridRouter {
  func wireup(_ cell: PhotoGridCell)
}

class PhotoGridRouterImp: PhotoGridRouter {
  func wireup(_ cell: PhotoGridCell) {
    cell.output = ImageDataInteractor()
  }
}
