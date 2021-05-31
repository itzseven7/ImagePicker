//
//  SearchListImageItemViewModel.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit
import Combine

class SearchListImageItemViewModel {
  var displayedImage: UIImage
  
  var selectedPublisher = CurrentValueSubject<Bool, Never>(false)
  
  var selected = false {
    didSet {
      selectedPublisher.send(selected)
    }
  }
  
  let image: Image
  
  init?(image: Image) throws {
    self.image = image
    
    let imageData = try Data(contentsOf: URL(string: image.previewURL)!)
    self.displayedImage = UIImage(data: imageData) ?? UIImage()
  }
}
