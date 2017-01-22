//
// Created by Qiao Zhang on 1/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit.UIImage

protocol ImageDataRemoteDataSource {
  func fetchImageDataAsync(
      url: URL,
      completion: @escaping (FetchImageDataResult) -> Void) -> FetchImageDataTask?
}

protocol FetchImageDataTask {
  func cancel()
}

struct FetchImageURLSessionDataTask: FetchImageDataTask {
  var task: URLSessionDataTask?
  func cancel() {
    task?.cancel()
  }
}

enum FetchImageDataResult {
  case success(Data)
  case failure
  case cancellation
}

class ImageDataStore {
  static let shared = ImageDataStore()
  private init() {}
  
  private let cache = NSCache<NSURL, NSData>()
  private let remoteImageDataSource: ImageDataRemoteDataSource =
      FlickrAPI.shared
  
  func fetchImageDataAsync(
      url: URL,
      completion: @escaping (FetchImageDataResult) -> Void)
          -> FetchImageDataTask? {
    
    if let imageData = cache.object(forKey: url as NSURL) {
      completion(.success(imageData as Data))
      return nil
    }
    
    let task = remoteImageDataSource.fetchImageDataAsync(url: url) {
      [unowned self] result in
      if case .success(let imageData) = result {
        self.cache.setObject(imageData as NSData, forKey: url as NSURL)
      }
      completion(result)
    }
    return task
  }
}
