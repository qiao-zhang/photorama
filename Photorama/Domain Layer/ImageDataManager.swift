//
// Created by Qiao Zhang on 1/17/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

protocol ImageDataManager: class {
  func fetchImageDataAsync(
    of url: URL,
    completion: @escaping (FetchImageDataResult) -> Void)
}

enum FetchImageDataResult {
  case success(Data)
  case cancelled
  case failure(Error)
}

class ImageDataManagerImp: ImageDataManager {
  var service: FetchImageDataRemotelyService
  var imageDataCache = NSCache<NSURL, NSData>()
  
  init(service: FetchImageDataRemotelyService) {
    self.service = service 
  }

  func fetchImageDataAsync(
    of url: URL,
    completion: @escaping (FetchImageDataResult) -> Void) {
    if let data = imageDataCache.object(forKey: url as NSURL) {
      OperationQueue.main.addOperation {
        completion(.success(data as Data))
      }
      return
    }
    service.fetchImageDataAsync(of: url) { [unowned self] result in
      if case .success(let data) = result {
        self.imageDataCache.setObject(data as NSData, forKey: url as NSURL)
      }
      completion(result)
    }
  }
}

protocol FetchImageDataRemotelyService {
  func fetchImageDataAsync(of url: URL,
                           completion: @escaping (FetchImageDataResult) -> Void)
}
