//
//  URLBuilder.swift
//  MySecondSubmission
//
//  Created by Andika Andriana on 07/09/25.
//

import Foundation

enum RAWGURLBuilder {
  static func makeURL(path: String, queries: [URLQueryItem] = []) -> URL? {
    guard var comp = URLComponents(string: APIConfig.baseURL.absoluteString) else { return nil }
    comp.path = path
    var items = queries
    items.append(URLQueryItem(name: "key", value: APIConfig.apiKey))
    comp.queryItems = items
    return comp.url
  }
}
