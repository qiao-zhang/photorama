//
// Created by Qiao Zhang on 1/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoCellPresenterOutput: class {
  func showImage(_ image: UIImage)
  func showFailure()
}

protocol FetchImageDataTask {
  func cancel()
}

class PhotoCellPresenter: PhotoCellOutput {
  unowned let output: PhotoCellPresenterOutput
  var fetchImageDataTask: FetchImageDataTask?
  
  init(output: PhotoCellPresenterOutput) {
    self.output = output
  }
  
  func loadImage(url: URL) {
    fetchImageDataTask?.cancel()

    fetchImageDataTask = ImageDataStore.shared.loadImageDataAsync(url: url) {
      [weak self] data in
      guard let strongSelf = self else { return }
      guard let data = data,
            let image = UIImage(data: data) else {
        return strongSelf.output.showFailure()
      }
      OperationQueue.main.addOperation {
        strongSelf.output.showImage(image)
      }
    }
  }
}
