//
// Created by Qiao Zhang on 1/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit.UIImage

protocol ImageDataRemoteDataSource {
  func fetchImageDataAsync(
      url: URL,
      completion: @escaping (Data?) -> Void) -> FetchImageDataTask?
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

class ImageDataStore {
  static let shared = ImageDataStore()
  private init() {}
  
  private let cache = NSCache<NSURL, NSData>()
  private let remoteImageDataSource: ImageDataRemoteDataSource =
      FlickrAPI.shared
  
  func loadImageDataAsync(url: URL, completion: @escaping (Data?) -> Void)
          -> FetchImageDataTask? {
    let cached = cache.object(forKey: url as NSURL)
    if let imageData = cached {
      completion(imageData as Data)
      return nil
    }
    let task = remoteImageDataSource.fetchImageDataAsync(url: url) {
      [unowned self] imageData in
      if let imageData = imageData {
        self.cache.setObject(imageData as NSData, forKey: url as NSURL)
      }
      completion(imageData)
    }
    return task
  }
}
