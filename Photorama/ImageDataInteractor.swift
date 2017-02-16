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

protocol FetchImageDataService {
  func cancelCurrentFetching()
  func fetchImageDataAsync(of url: URL,
                           completion: @escaping (FetchImageDataResult) -> Void)
}

class ImageDataInteractor: ImageDataInteractorInput {
  var fetchImageDataService: FetchImageDataService?
  var output: ImageDataInteractorOutput?

  func fetchImageData(of url: URL) {
    fetchImageDataService?.cancelCurrentFetching()
    fetchImageDataService?.fetchImageDataAsync(of: url) { [weak self] result in
      self?.output?.doneFetchingImageData(result: result)
    }
  }

  func cancelFetchingImageData() {
    fetchImageDataService?.cancelCurrentFetching()
  }
}
