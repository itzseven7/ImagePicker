//
//  SearchListViewModel.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit
import Combine

protocol SearchListViewModelProtocol: AnyObject {
  var isLoading: CurrentValueSubject<Bool, Never> { get }
  
  var isDetailButtonEnabled: CurrentValueSubject<Bool, Never> { get }
  
  var previews: [SearchListImageItemViewModel] { get }
  
  func searchImages(with keywords: String) -> AnyPublisher<Void, Error>
  
  func selectImage(at indexPath: IndexPath)
  
  func getSelectedImages() -> [UIImage]
}

class SearchListViewModel: SearchListViewModelProtocol {
  private static var separator = ","
  
  var isLoading = CurrentValueSubject<Bool, Never>(false)
  
  var isDetailButtonEnabled = CurrentValueSubject<Bool, Never>(false)
  
  var previews: [SearchListImageItemViewModel] = []
  
  let worker: ImageWorkable
  
  init(worker: ImageWorkable = ImageWorker()) {
    self.worker = worker
  }
  
  func searchImages(with keywords: String) -> AnyPublisher<Void, Error> {
    isLoading.send(true)
    
    return worker.getImages(withKeywords: prepareKeywordsForQuery(keywords))
      .flatMap { response -> AnyPublisher<[Image], Error> in
        return Just(response.hits).setFailureType(to: Error.self).eraseToAnyPublisher()
      }
      .tryMap({ images in
        return try images.map { try SearchListImageItemViewModel(image: $0 )}
      })
      .flatMap({ [weak self] images -> AnyPublisher<Void, Error> in
        self?.previews = images.compactMap { $0 }
        self?.isLoading.send(false)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
      })
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  func selectImage(at indexPath: IndexPath) {
    previews[indexPath.row].selected.toggle()
    
    let canShowPreview = getSelectedImages().count >= 2 ? true : false
    isDetailButtonEnabled.send(canShowPreview)
  }
  
  func getSelectedImages() -> [UIImage] {
    return previews.filter { $0.selected }.map { $0.displayedImage }
  }
  
  func prepareKeywordsForQuery(_ query: String) -> String {
    query.replacingOccurrences(of: SearchListViewModel.separator, with: "+")
  }
}
