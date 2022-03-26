//
//  BusinessRequestModel.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import CoreLocation

struct BusinessRequestModel {
  let term: String?
  let location: CLLocation
  var category: CategoryType = .food
  let sortBy: SortingType
  var limit: Int = 50
  
  init(term: String?, location: CLLocation = LocationService.shared.userLocation,
       category: CategoryType = .food, sortBy: SortingType = .distance) {
      self.term = term
      self.location = location
      self.category = category
      self.sortBy = sortBy
  }
}

extension BusinessRequestModel: YelpEndPoint {
    var url: URL? {
        var urlComponents = URLComponents(string: AppConstants.baseUrl)!
        var quries = [URLQueryItem]()
        if let term = term {
            quries.append(URLQueryItem(name: "term", value: term))
        }
        quries.append(URLQueryItem(name: "latitude", value: "\(location.coordinate.latitude)"))
        quries.append(URLQueryItem(name: "longitude", value: "\(location.coordinate.longitude)"))
        quries.append(URLQueryItem(name: "categories", value: category.rawValue))
        quries.append(URLQueryItem(name: "sort_by", value: self.sortBy.rawValue))
        if limit > 0 {
            quries.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }
        urlComponents.queryItems = quries
        return urlComponents.url
    }
}
enum CategoryType: String, Codable {
  case food, restaurant, all
}

enum SortingType: String, Codable {
  case rating, distance
}
