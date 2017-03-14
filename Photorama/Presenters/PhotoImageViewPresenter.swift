//
// Created by Qiao Zhang on 3/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation
import UIKit.UIImage

class PhotoImageViewPresenterImp: PhotoImageViewPresenter {
  unowned let view: PhotoImageView
  unowned let imageDataManager: ImageDataManager
  var imageURL: URL

  init(view: PhotoImageView,
       imageDataManager: ImageDataManager,
       imageURL: URL) {
    self.view = view
    self.imageDataManager = imageDataManager
    self.imageURL = imageURL
  }

  func viewWillAppear() {
    imageDataManager.fetchImageDataAsync(of: imageURL) {
      [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .cancelled:
        return
      case .failure(let error):
        return
      case .success(let imageData):
        guard let image = UIImage(data: imageData) else {
          return
        }
        strongSelf.view.onFetched(image)
      }
    }
  }
}
