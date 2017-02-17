//
// Created by Qiao Zhang on 2/16/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

class FetchImageDataWithURLSessionAPIService: FetchImageDataService {
  
  private var currentFetching: URLSessionDataTask?
  private let session: URLSession = {
    let config = URLSessionConfiguration.default
    return URLSession(configuration: config)
  }()
  
  func cancelCurrentFetching() {
    currentFetching?.cancel()
  }

  func fetchImageDataAsync(
      of url: URL,
      completion: @escaping (FetchImageDataResult) -> Void) {
    let request = URLRequest(url: url)
    currentFetching = session.dataTask(with: request) { data, response, error in
      let result: FetchImageDataResult
      if let data = data {
        result = .success(data)
      } else if let error = error as? NSError {
        if error.domain == NSURLErrorDomain,
           error.code == NSURLErrorCancelled {
          result = .failure(.cancelled)
        }
        result = .failure(.other(error))
      }
    }
    currentFetching!.resume()
  }

}