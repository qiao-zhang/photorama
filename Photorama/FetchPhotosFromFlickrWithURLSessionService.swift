//
// Created by Qiao Zhang on 2/16/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

class FetchPhotosFromFlickrWithURLSessionService: FetchPhotosService {

  private var currentFetching: URLSessionDataTask?
  private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return df
  }()
  
  func cancelCurrentFetching() {
    currentFetching?.cancel()
  }

  func fetchPhotosAsync(of category: PhotoCategory,
                        completion: @escaping (FetchPhotosResult) -> Void) {
    let url = urlFromFlickrForPhotos(of: category)
    let request = URLRequest(url: url)
    currentFetching = urlSession.dataTask(with: request) {
      [weak self] data, _, error in
      guard let strongSelf = self else { return }
      
      let result: FetchPhotosResult
      if let error = error as? NSError {
        if error.domain == NSURLErrorDomain,
           error.code == NSURLErrorCancelled {
          result = .failure(.cancelled)
        }
        result = .failure(.other(error))
      } else if let jsonData = data,
                let photos = strongSelf.photos(fromJSON: jsonData) {
        result = .success(photos)
      }
      completion(result)
    }
    currentFetching!.resume()
  }
  
  private func urlFromFlickrForPhotos(of category: PhotoCategory) -> URL {
    let url: URL
    switch category {
    case .interesting:
      url = FlickrAPI.interestingPhotosURL
    case .recent:
      url = FlickrAPI.recentPhotosURL
    }   
    return url
  }
  
  private func photos(fromJSON data: Data) -> [Photo]? {
    guard
        let jsonObject = try? JSONSerialization.jsonObject(with: data,
                                                           options: []),
        let jsonDict = jsonObject as? [AnyHashable: Any],
        let photosDict = jsonDict["photos"] as? [String: Any],
        let photosArray = photosDict["photo"] as? [[String: Any]] else {
      return nil
    }

    let photos = photosArray.flatMap {
      photo(fromJSON: $0)
    }

    if photos.isEmpty && !photosArray.isEmpty { return nil }

    return photos
  }

  private func photo(fromJSON json: [String: Any]) -> Photo? {
    guard let photoID = json["id"] as? String,
          let title = json["title"] as? String,
          let urlString = json["url_h"] as? String,
          let url = URL(string: urlString),
          let dateString = json["datetaken"] as? String,
          let dateTaken = dateFormatter.date(from:dateString) else {
      return nil
    }
    return Photo(title: title, remoteURL: url,
                 photoID: photoID, dataTaken: dateTaken)
  }
}
