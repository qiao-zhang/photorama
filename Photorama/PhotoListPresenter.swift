//
// Created by Qiao Zhang on 1/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol PhotoListPresenterOutput: class {
  func showFailure()
  func showPhotoCells(_ photoCellItems: [PhotoCellItem])
}

class PhotoListPresenter: PhotoListViewOutput {

  weak var output: PhotoListPresenterOutput!
  private var fetchPhotoTask: FetchPhotosTask?

  func loadPhotoCellItems(category: PhotoCellItemCategory) {

    let photoCategory: PhotoCategory
    switch category {
    case .interesting: photoCategory = .interesting
    case .recent: photoCategory = .recent
    }

    fetchPhotoTask?.cancel()

    fetchPhotoTask = PhotoStore.shared.fetchPhotosAsync(
        category: photoCategory) { [unowned self] photos in

      guard let photos = photos else {
        self.output.showFailure()
        return
      }

      let photoItems = photos.map {
        PhotoCellItem(title: $0.title,
                      remoteURL: $0.remoteURL)
      }

      OperationQueue.main.addOperation {
        self.output.showPhotoCells(photoItems)
      }
    }
  }

}
