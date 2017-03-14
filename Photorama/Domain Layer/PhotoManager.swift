//
// Created by Qiao Zhang on 1/17/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol PhotoManager: class {
  var photoCategories: [PhotoCategory] { get }
  func fetchPhotosAsync(of category: PhotoCategory,
                        completion: @escaping (FetchPhotosResult) -> Void) 
  func fetchPhotosRemotelyAsync(
    of category: PhotoCategory,
    completion: @escaping (FetchPhotosResult) -> Void) 
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

class PhotoManagerImp: PhotoManager {
  let service: FetchPhotosRemotelyService
  init(service: FetchPhotosRemotelyService) {
    self.service = service
  }
  
  var photos: [PhotoCategory: [Photo]] = [:]

  let photoCategories = PhotoCategory.allValues

  func fetchPhotosAsync(of category: PhotoCategory,
                        completion: @escaping (FetchPhotosResult) -> Void) {
    if let photos = self.photos[category] {
      return completion(.success(photos))
    }
    
    fetchPhotosRemotelyAsync(of: category, completion: completion)
  }

  func fetchPhotosRemotelyAsync(
    of category: PhotoCategory,
    completion: @escaping (FetchPhotosResult) -> Void) {
    
    service.fetchPhotosAsync(of: category) { [unowned self] result in
      if case let .success(photos) = result {
        self.photos[category] = photos
      }
      completion(result)
    }
  }
}
