//
// Created by Qiao Zhang on 1/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

protocol PhotoListCellPresenterOutput: class {
  func showImage(_ image: UIImage)
  func showFailure()
}

class PhotoListCellPresenter: PhotoListCellOutput {
  unowned let output: PhotoListCellPresenterOutput
  var fetchImageDataTask: FetchImageDataTask?
  
  init(output: PhotoListCellPresenterOutput) {
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
