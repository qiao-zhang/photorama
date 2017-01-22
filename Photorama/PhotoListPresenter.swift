//
// Created by Qiao Zhang on 1/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol PhotoListPresenterOutput: class {
  func showFailure()
  func showPhotoListCells(_ photoListCellItems: [PhotoListCellItem])
}

class PhotoListPresenter: PhotosInteractorOutput {
  
  unowned let output: PhotoListPresenterOutput

  init(output: PhotoListPresenterOutput) {
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
    let photoListCellItems: [PhotoListCellItem] = photos.map {
      PhotoListCellItem(title: $0.title, imageURL: $0.remoteURL)
    }
    OperationQueue.main.addOperation { [weak self] in
      self?.output.showPhotoListCells(photoListCellItems)
    }
  }
  
  private func handleFailure(error: FetchPhotosError) {
    OperationQueue.main.addOperation { [weak self] in
      self?.output.showFailure()
    }
  }
  
}
