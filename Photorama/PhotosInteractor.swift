//
// Created by Qiao Zhang on 1/17/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol PhotosInteractorOutput {
  func process(_ result: FetchPhotosResult)
}


class PhotosInteractor {
  var output: PhotosInteractorOutput
  private var fetchPhotosTask: FetchPhotosTask?

  init(output: PhotosInteractorOutput) {
    self.output = output
  }

  func fetchPhotos(category: PhotoCategory) {
    fetchPhotosTask?.cancel()
    fetchPhotosTask = PhotoStore.shared.fetchPhotosAsync(
        category: category) { [weak self] result in
      
      guard let strongSelf = self else { return }
      
      OperationQueue.main.addOperation {
        strongSelf.output.process(result)
      }
    }
  }
}

extension PhotosInteractor: PhotoListViewControllerOutput {
  func loadInterestingPhotoListCellItems() {
    fetchPhotos(category: .interesting)
  }
  
  func loadRecentPhotoListCellItems() {
    fetchPhotos(category: .recent)
  }
}

extension PhotosInteractor: PhotoGridViewControllerOutput {
  func loadInterestingPhotoGridCellItems() {
    fetchPhotos(category: .interesting)
  }

  func loadRecentPhotoGridCellItems() {
    fetchPhotos(category: .recent)
  }
}