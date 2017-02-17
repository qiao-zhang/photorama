//
// Created by Qiao Zhang on 1/11/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation

class FlickrAPI {
  
  fileprivate static let baseURLString = "https://api.flickr.com/services/rest"
  fileprivate static let apiKey = "a6d819499131071f158fd740860a5a88"
  
  enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
    case recentPhotos = "flickr.photos.getRecent"
  }
  
  static var interestingPhotosURL: URL {
    return flickrURL(method: .interestingPhotos)
  }

  static var recentPhotosURL: URL {
    return flickrURL(method: .recentPhotos)
  }
  
  private static func flickrURL(
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
}
