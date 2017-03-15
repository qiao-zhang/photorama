//
// Created by Qiao Zhang on 2/16/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

class FetchImageDataWithURLSessionAPIService: FetchImageDataRemotelyService {
  
  func fetchImageDataAsync(
    of url: URL,
    completion: @escaping (FetchImageDataResult) -> Void) {
    
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) {
      data, _, error in
      
      let result: FetchImageDataResult
      if let data = data {
        result = .success(data)
      } else {
        let error = error as! NSError
        if error.domain == NSURLErrorDomain, error.code == NSURLErrorCancelled {
          result = .cancelled
        } else {
          result = .failure(error)
        }
      }
      OperationQueue.main.addOperation {
        completion(result)
      }
    }
    task.resume()
  }

}
