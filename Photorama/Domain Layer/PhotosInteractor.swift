//
// Created by Qiao Zhang on 1/17/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol PhotosInteractorOutput {
  func didFetchPhotos(result: FetchPhotosResult)
}

protocol PhotosInteractor {
  func fetchPhotos(of category: PhotoCategory) 
  func fetchPhotosRemotely(of category: PhotoCategory)
}

enum FetchPhotosResult {
  case success([Photo])
  case cancelled
  case failure(Error)
}

protocol FetchPhotosRemotelyService {
  func fetchPhotosAsync(of category: PhotoCategory,
                        completion: @escaping (FetchPhotosResult) -> Void)
}

class PhotosInteractorImp: PhotosInteractor {
  var output: PhotosInteractorOutput?
  var service: FetchPhotosRemotelyService?
  var photos: [PhotoCategory: [Photo]] = [:]

  func fetchPhotos(of category: PhotoCategory) {
    if let photos = self.photos[category] {
      output?.didFetchPhotos(result: .success(photos))
      return
    }
    
    fetchPhotosRemotely(of: category)
  }

  func fetchPhotosRemotely(of category: PhotoCategory) {
    service?.fetchPhotosAsync(of: category) { [weak self] result in
      guard let strongSelf = self else { return }
      if case let .success(photos) = result {
        strongSelf.photos[category] = photos
      }
      strongSelf.output?.didFetchPhotos(result: result)
    }
  }

}
