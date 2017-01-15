//
// Created by Qiao Zhang on 1/11/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol PhotoRemoteDataSource {
  func fetchPhotosAsync(category: PhotoCategory,
                        completion: @escaping ([Photo]?) -> Void)
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

class PhotoStore {
  
  static let shared = PhotoStore()
  private init() {}
  
  private let remotePhotoDataSource: PhotoRemoteDataSource = FlickrAPI.shared
  
  func fetchPhotosAsync(category: PhotoCategory,
                        completion: @escaping ([Photo]?) -> Void)
          -> FetchPhotosTask? {
    let task = remotePhotoDataSource.fetchPhotosAsync (category: category) {
      photos in
      completion(photos)
    }
    return task
  }
}
