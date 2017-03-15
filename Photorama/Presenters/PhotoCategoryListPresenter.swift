//
// Created by Qiao Zhang on 3/6/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

class PhotoCategoryListPresenter: PhotoCategoryListEventHandler {
  
  unowned let categoryList: PhotoCategoryList
  unowned let photoManager: PhotoManager
  
  init(categoryList: PhotoCategoryList, photoManager: PhotoManager) {
    self.categoryList = categoryList
    self.photoManager = photoManager
  }
  
  func viewWillAppear() {
    categoryList.categoryNames = photoManager.photoCategories.map {
      switch $0 {
      case .interesting:
        return "Interesting"
      case .recent:
        return "Recent"
      }
    }
  }
}