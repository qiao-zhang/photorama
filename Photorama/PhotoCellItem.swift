//
//  PhotoCellItem.swift
//  Photorama
//
//  Created by Qiao Zhang on 1/14/17.
//  Copyright © 2017 Qiao Zhang. All rights reserved.
//
import Foundation

struct PhotoCellItem {
  let title: String
  let remoteURL: URL
}

enum PhotoCellItemCategory: String {
  case interesting = "Interesting"
  case recent = "Recent"
  
  static var allCases: [PhotoCellItemCategory] {
    return [.interesting, .recent]
  }
}
