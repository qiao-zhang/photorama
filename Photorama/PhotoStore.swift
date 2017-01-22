//
// Created by Qiao Zhang on 1/11/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol PhotoRemoteDataSource {
  func fetchPhotosAsync(
      category: PhotoCategory,
      completion: @escaping (FetchPhotosResult) -> Void)
          -> FetchPhotosTask
}

protocol FetchPhotosTask {
  func cancel()
}

struct FetchPhotosURLSessionDataTask: FetchPhotosTask {
  var task: URLSessionDataTask?
  func cancel() {
    task?.cancel()
  }
}

enum FetchPhotosResult {
  case success([Photo])
  case failure(FetchPhotosError)
  case cancellation
}

enum FetchPhotosError {
  case requestFailed(Error)
  case jsonWrongFormat
}


class PhotoStore {
  
  static let shared = PhotoStore()
  private init() {}
  
  private let remotePhotoDataSource: PhotoRemoteDataSource = FlickrAPI.shared
  
  func fetchPhotosAsync(
      category: PhotoCategory,
      completion: @escaping (FetchPhotosResult) -> Void)
          -> FetchPhotosTask? {
    let task = remotePhotoDataSource.fetchPhotosAsync(category: category) {
      result in
      completion(result)
    }
    return task
  }
}
