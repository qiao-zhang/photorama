//
// Created by Qiao Zhang on 1/11/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

struct Photo {
  let title: String
  let remoteURL: URL
  let photoID: String
  let dateTaken: Date
}

enum PhotoCategory {
  case interesting
  case recent
  
  static let allValues: [PhotoCategory] = [.interesting, .recent]
}
