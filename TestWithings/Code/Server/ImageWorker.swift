//
//  ImageWorker.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import Foundation
import Combine

protocol ImageWorkable {
  func getImages(withKeywords keywords: String) -> AnyPublisher<ImageListResponse, Error>
}

class ImageWorker: ImageWorkable {
  let session = URLSession.shared
  let queue = DispatchQueue(label: "ImageWorkerQueue", qos: .userInitiated)
  let decoder = JSONDecoder()
  
  func getImages(withKeywords keywords: String) -> AnyPublisher<ImageListResponse, Error> {
    return Future<URL, Error> { promise in
      var request: URLRequest?
      
      do {
        request = try Router.getImages(keywords: keywords).asURLRequest()
      } catch {
        promise(.failure(error))
      }
      
      guard let urlRequest = request else { return promise(.failure(RoutableError.invalidBaseURL)) }
      
      promise(.success(urlRequest.url!))
    }
    .mapError({ error in
      return URLError(_nsError: NSError(domain: "Invalid base URL", code: -1, userInfo: nil))
    })
    .flatMap { url -> URLSession.DataTaskPublisher in
      self.session.dataTaskPublisher(for: url)
    }
    .tryMap { data, response in
      try self.decoder.decode(ImageListResponse.self, from: data)
    }
    .eraseToAnyPublisher()
  }
}
