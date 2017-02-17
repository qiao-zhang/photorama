//
// Created by Qiao Zhang on 1/17/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol PhotosInteractorOutput {
  func doneFetchingPhotos(result: FetchPhotosResult)
}

protocol PhotosInteractor {
  func fetchPhotos(of category: PhotoCategory) 
  func cancelFetchingPhotos()
}

enum FetchPhotosResult {
  case success([Photo])
  case failure(FetchPhotosError)
}

enum FetchPhotosError {
  case cancelled
  case other(Error)
}

protocol FetchPhotosService {
  func cancelCurrentFetching()
  func fetchPhotosAsync(of category: PhotoCategory,
                        completion: @escaping (FetchPhotosResult) -> Void)
}

class PhotosInteractorImp: PhotosInteractor {
  var output: PhotosInteractorOutput?
  var service: FetchPhotosService?

  func fetchPhotos(of category: PhotoCategory) {
    service?.cancelCurrentFetching()
    service?.fetchPhotosAsync(of: category) { [weak self] result in
      self?.output?.doneFetchingPhotos(result: result)
    }
  }

  func cancelFetchingPhotos() {
    service?.cancelCurrentFetching()
  }
}
