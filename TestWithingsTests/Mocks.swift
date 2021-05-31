//
//  Mocks.swift
//  TestWithingsTests
//
//  Created by Romain on 31/05/2021.
//

import UIKit
import Combine
@testable import TestWithings

class ImageWorkerMock: ImageWorkable {
  
  var getImagesPublisher = PassthroughSubject<ImageListResponse, Error>()
  
  func getImages(withKeywords keywords: String) -> AnyPublisher<ImageListResponse, Error> {
    getImagesPublisher = PassthroughSubject<ImageListResponse, Error>()
    
    return getImagesPublisher.eraseToAnyPublisher()
  }
}

class SearchListViewModelMock: SearchListViewModelProtocol {
  var isLoading = CurrentValueSubject<Bool, Never>(false)
  
  var previews: [SearchListImageItemViewModel] = []
  
  var selectedImages = [UIImage]()
  
  var selectImageIsCalled = false
  
  var searchImagesSubject = PassthroughSubject<Void, Error>()
  
  func searchImages(with keywords: String) -> AnyPublisher<Void, Error> {
    searchImagesSubject = PassthroughSubject<Void, Error>()
    
    return searchImagesSubject.eraseToAnyPublisher()
  }
  
  func selectImage(at indexPath: IndexPath) {
    selectImageIsCalled = true
  }
  
  func getSelectedImages() -> [UIImage] {
    return selectedImages
  }
}

class ImageFlowCoordinatorMock: ImageFlowCoordinable {
  var showDetailViewIsCalled = false
  
  func showDetailView(for images: [UIImage]) {
    showDetailViewIsCalled = true
  }
}

class ImageModelMock: ImageModel {
  var id: Int
  
  var pageURL: String
  
  var previewURL: String
  
  var imageWidth: Int
  
  var imageHeight: Int
  
  internal init(id: Int = 1, pageURL: String = "url", previewURL: String = "https://cdn.pixabay.com/photo/2018/01/28/11/24/sunflower-3113318_150.jpg", imageWidth: Int = 100, imageHeight: Int = 100) {
    self.id = id
    self.pageURL = pageURL
    self.previewURL = previewURL
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
  }
}
