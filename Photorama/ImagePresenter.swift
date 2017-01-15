//
// Created by Qiao Zhang on 1/15/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol ImagePresenterOutput: class {
  func showFailure()
  func showImage(_ image: UIImage)
}

class ImagePresenter: ImageViewOutput {
  
  unowned let output: ImagePresenterOutput
  var fetchImageDataTask: FetchImageDataTask?

  init(output: ImagePresenterOutput) {
    self.output = output
  }

  func loadImage(url: URL) {
    fetchImageDataTask = ImageDataStore.shared.loadImageDataAsync(url: url) {
      [weak self] data in
      guard let strongSelf = self else { return }
      guard let data = data, let image = UIImage(data: data) else {
        OperationQueue.main.addOperation {
          strongSelf.output.showFailure()
        }
        return
      }
      OperationQueue.main.addOperation {
        strongSelf.output.showImage(image)
      }
    }
  }
}
