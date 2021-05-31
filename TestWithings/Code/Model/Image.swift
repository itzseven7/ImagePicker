//
//  Image.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import Foundation

protocol ImageModel {
  var id: Int { get }
  var pageURL: String { get }
  var previewURL: String { get }
  var imageWidth: Int { get }
  var imageHeight: Int { get }
}

/// The image represents an image object on Pixabay
class Image: Decodable, Equatable, ImageModel {
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
