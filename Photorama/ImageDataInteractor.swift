//
// Created by Qiao Zhang on 1/17/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol ImageDataInteractorOutput {
  func doneFetchingImageData(result: FetchImageDataResult)
}

protocol ImageDataInteractorInput {
  func fetchImageData(of url: URL)
  func cancelFetchingImageData()
}

enum FetchImageDataResult {
  case success(Data)
  case failure(FetchImageDataFailureReason)
}

enum FetchImageDataFailureReason: Error {
  case cancelled
  case other(Error)
}

class ImageDataInteractor: ImageDataInteractorInput {
  var fetchImageDataTask: FetchImageDataTask?
  let output: ImageDataInteractorOutput

  init(output: ImageDataInteractorOutput) {
    self.output = output
  }

  func fetchImageData(of url: URL) {
    fetchImageDataTask?.cancel()

    fetchImageDataTask = ImageDataStore.shared.fetchImageDataAsync(url: url) {
      [weak self] result in
      self?.output.doneFetchingImageData(result: result)
    }
  }

  func cancelFetchingImageData() {
    fetchImageDataTask?.cancel()
  }
}
