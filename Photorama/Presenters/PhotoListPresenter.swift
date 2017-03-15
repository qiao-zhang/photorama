//
// Created by Qiao Zhang on 3/7/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

class PhotoListPresenterImp: PhotoListPresenter {

  unowned let view: PhotoList
  unowned let photoManager: PhotoManager
  let categoryName: String
  
  let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    return df
  }()
  
  init(photoList: PhotoList,
       photoManager: PhotoManager,
       categoryName: String) {
    self.view = photoList
    self.photoManager = photoManager
    self.categoryName = categoryName
  }

  func viewWillAppear() {
    fetchPhotoListItems()
    view.changeTitle(to: categoryName)
  }

  func refreshButtonTapped() {
    fetchPhotoListItems()
  }
  
  private func fetchPhotoListItems() {
    let category: PhotoCategory
    switch categoryName {
    case "Interesting":
      category = .interesting
    case "Recent":
      category = .recent
    default:
      fatalError("Invalid category name")
    }
    photoManager.fetchPhotosAsync(of: category) { [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .cancelled:
        return
      case .failure(let error):
        strongSelf.view.onFetchingFailed(with: error.localizedDescription)
      case .success(let photos):
        let photoListItems = photos.map {
          PhotoListItem(
            title: $0.title,
            dateTaken: strongSelf.dateFormatter.string(from: $0.dateTaken),
            imageURL: $0.remoteURL)
        }
        strongSelf.view.onFetched(photoListItems)
      }
    }
  }

}
