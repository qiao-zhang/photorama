//
// Created by Qiao Zhang on 3/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation
import UIKit.UIImage

class PhotoGridPresenterImp: PhotoGridPresenter {
  
  unowned let view: PhotoGrid
  unowned let photoManager: PhotoManager
  unowned let imageDataManager: ImageDataManager
  let categoryName: String
  
  init(view: PhotoGrid, photoManager: PhotoManager,
       imageDataManager: ImageDataManager, categoryName: String) {
    self.view = view
    self.photoManager = photoManager
    self.imageDataManager = imageDataManager
    self.categoryName = categoryName
  }
  
  func viewWillAppear() {
    fetchPhotoGridItems()
  }

  func willDisplayCell(for item: PhotoGridItem) {
    imageDataManager.fetchImageDataAsync(of: item.imageURL) {
      [weak self] result in
      guard let strongSelf = self else { return }
      guard case .success(let data) = result,
            let image = UIImage(data: data) else { return }
      strongSelf.view.onFetched(image, for: item)
    }
  }

  private func fetchPhotoGridItems() {
    let category: PhotoCategory
    switch categoryName {
    case "Interesting":
      category = .interesting
    case "Recent":
      category = .recent
    default:
      fatalError("Invalid category name")
    }
    photoManager.fetchPhotosAsync(of: category) { [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .cancelled:
        return
      case .failure:
        return
      case .success(let photos):
        let items = photos.map {
          PhotoGridItem(title: $0.title, imageURL: $0.remoteURL, id: $0.photoID)
        }
        strongSelf.view.onFetched(items)
      }
    }
  }

}
