//
//  Router.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import Foundation

enum RoutableError: Error {
  case invalidBaseURL
  case invalidURLForComponents
  case invalidImageQuery
}

protocol Routable {
  var baseURL: String { get }
  var path: String { get }
  var method: String { get }
  var parameters: [String: String] { get }
}

enum Router: Routable {
  case getImages(keywords: String)
  
  var baseURL: String {
    switch self {
    case .getImages:
      return Environment.baseURL
    }
  }
  
  var path: String {
    switch self {
    case .getImages:
      return ""
    }
  }
  
  var method: String {
    switch self {
    case .getImages:
      return "GET"
    }
  }
  
  var parameters: [String: String] {
    var params = ["key": Environment.apiKey, "image_type": "photo", "safesearch": "true"]
    
    switch self {
    case .getImages(let keywords):
      params["q"] = RouterHelper.prepareKeywordsForQuery(keywords)
    }
    
    return params
  }
}

extension Routable {
  func asURLRequest() throws -> URLRequest {
    guard var url = URL(string: baseURL) else {
      throw RoutableError.invalidBaseURL
    }
    
    url.appendPathComponent(path)
    
    var request = URLRequest(url: url)
    
    if !parameters.isEmpty {
      guard var components = URLComponents(string: url.absoluteString) else { throw RoutableError.invalidURLForComponents }
      
      components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
      components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
      request = URLRequest(url: components.url!)
    }
    
    request.httpMethod = method
    
    return request
  }
}
