//
//  ImagePreviewViewModel.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit
import Combine

protocol ImagePreviewViewModelProtocol {
  var images: [UIImage] { get }
  
  var currentImage: UIImage { get }
  
  func start()
  func onNewImage() -> AnyPublisher<Void, Never>
}

class ImagePreviewViewModel: ImagePreviewViewModelProtocol {
  var images: [UIImage]
  
  var currentImage: UIImage {
    return images[currentIndex]
  }
  
  var timer: Timer?
  
  let newImageSubject = PassthroughSubject<Void, Never>()
  
  var currentIndex = 0
  
  init(images: [UIImage]) {
    self.images = images
  }
  
  func start() {
    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] timer in
      guard let sSelf = self else { return }
      
      sSelf.currentIndex += 1
      
      guard sSelf.currentIndex < sSelf.images.count else {
        timer.invalidate()
        return
      }
      
      self?.newImageSubject.send(())
    })
  }
  
  func onNewImage() -> AnyPublisher<Void, Never> {
    return newImageSubject
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
