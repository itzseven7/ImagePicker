//
//  Image.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import Foundation

class Image: Decodable, Equatable {
  var id: Int
  var pageURL: String
  var previewURL: String
  var imageWidth: Int
  var imageHeight: Int
  
  static func == (lhs: Image, rhs: Image) -> Bool {
    return lhs.id == rhs.id
  }
}

class ImageListResponse: Decodable {
  var total: Int
  var hits: [Image]
}
