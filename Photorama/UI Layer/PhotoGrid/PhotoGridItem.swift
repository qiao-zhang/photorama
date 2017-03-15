//
// Created by Qiao Zhang on 3/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

struct PhotoGridItem: Equatable {
  let title: String
  let imageURL: URL
  let id: String
  
  static func == (lhs: PhotoGridItem, rhs: PhotoGridItem) -> Bool {
    return lhs.id == rhs.id
  }
}
