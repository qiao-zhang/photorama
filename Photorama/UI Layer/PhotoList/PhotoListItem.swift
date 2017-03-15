//
// Created by Qiao Zhang on 3/7/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

struct PhotoListItem: Equatable {
  let title: String
  let dateTaken: String
  let imageURL: URL
}

func ==(left: PhotoListItem, right: PhotoListItem) -> Bool {
  if left.title != right.title { return false }
  if left.dateTaken != right.dateTaken { return false }
  if left.imageURL != right.imageURL { return false }
  return true
}
