//
// Created by Qiao Zhang on 1/11/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

class FlickrAPI {
  static let shared = FlickrAPI()
  private init() {
  }
  
  fileprivate static let baseURLString = "https://api.flickr.com/services/rest"
  fileprivate static let apiKey = "a6d819499131071f158fd740860a5a88"
  
  enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
    case recentPhotos = "flickr.photos.getRecent"
  }
  
  fileprivate let session: URLSession = {
    let config = URLSessionConfiguration.default
    return URLSession(configuration: config)
  }()
  
  fileprivate func flickrURL(
      method: Method,
      parameters: [String: String]? = ["extras": "url_h,date_taken"]) -> URL {
    var components = URLComponents(string: FlickrAPI.baseURLString)!
    
    var queryItems = [URLQueryItem]()
    
    let baseParams = ["method": method.rawValue,
                      "format": "json",
                      "nojsoncallback": "1",
                      "api_key": FlickrAPI.apiKey]
    
    [baseParams, parameters ?? [:]].forEach {
      for (key, value) in $0 {
        let item = URLQueryItem(name: key, value: value)
        queryItems.append(item)
      }
    }
    
    components.queryItems = queryItems
    return components.url!
  }
  
  fileprivate let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return df
  }()
}
  
extension FlickrAPI: PhotoRemoteDataSource {
  
  private var interestingPhotosURL: URL {
    return flickrURL(method: .interestingPhotos)
  }
  
  private var recentPhotosURL: URL {
    return flickrURL(method: .recentPhotos)
  }

  func fetchPhotosAsync(category: PhotoCategory,
                        completion: @escaping ([Photo]?) -> Void)
          -> FetchPhotosTask {
    let url: URL
    switch category {
    case .interesting:
      url = interestingPhotosURL
    case .recent:
      url = recentPhotosURL
    }
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request) { data, response, error in
      if let jsonData = data {
        let photos = self.photos(fromJSON: jsonData)
        completion(photos)
      } else if let requestError = error {
        print("\(requestError)")
      } else {
        print("Unexpected error with the request")
      }
    }
    task.resume()
    return FetchPhotosURLSessionDataTask(task: task)
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

extension FlickrAPI: ImageDataRemoteDataSource {
  func fetchImageDataAsync(
      url: URL,
      completion: @escaping (Data?) -> Void) -> FetchImageDataTask? {
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request) { data, response, error in
      guard let data = data else { return }
      completion(data)
    }
    task.resume()
    return FetchImageURLSessionDataTask(task: task)
  }

}