//
// Created by Qiao Zhang on 1/17/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol ImageDataInteractorOutput {
  func imageDataFetched(_ imageData: Data?)
}

class ImageDataInteractor {
  var fetchImageDataTask: FetchImageDataTask?
  let output: ImageDataInteractorOutput

  init(output: ImageDataInteractorOutput) {
    self.output = output
  }

  fileprivate func fetchImageData(url: URL) {
    fetchImageDataTask?.cancel()

    fetchImageDataTask = ImageDataStore.shared.fetchImageDataAsync(url: url) {
      [weak self] result in
      guard let strongSelf = self else {
        return
      }
      switch result {
      case .success(let imageData):
        strongSelf.output.imageDataFetched(imageData)
      case .failure:
        strongSelf.output.imageDataFetched(nil)
      case .cancellation:
        break
      }
    }
  }
}

extension ImageDataInteractor: PhotoGridCellOutput, PhotoListCellOutput,
    ImageViewControllerOutput {
  func loadImage(url: URL) {
    fetchImageData(url: url)
  }

  func cancelLoadingImage() {
    fetchImageDataTask?.cancel()
    fetchImageDataTask = nil
  }
}
