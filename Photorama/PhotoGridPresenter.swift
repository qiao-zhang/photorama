//
// Created by Qiao Zhang on 1/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol PhotoGridPresenterOutput: class {
  func showFailure()
  func showPhotoGridCells(_ photoGridCellItems: [PhotoGridCellItem])
}

class PhotoGridPresenter: PhotosInteractorOutput {

  unowned let output: PhotoGridPresenterOutput
  
  init(output: PhotoGridPresenterOutput) {
    self.output = output
  }

  func process(_ result: FetchPhotosResult) {
    switch result {
    case .success(let photos):
      handlePhotos(photos)
    case .failure(let error):
      handleFailure(error: error)
    case .cancellation:
      break
    }
  }
  
  private func handlePhotos(_ photos: [Photo]) {
    let photoGridCellItems: [PhotoGridCellItem] = photos.map {
      PhotoGridCellItem(title: $0.title, imageURL: $0.remoteURL)
    }
    OperationQueue.main.addOperation { [weak self] in
      self?.output.showPhotoGridCells(photoGridCellItems)
    }
  }
  
  private func handleFailure(error: FetchPhotosError) {
    OperationQueue.main.addOperation { [weak self] in
      self?.output.showFailure()
    }
  }
}
