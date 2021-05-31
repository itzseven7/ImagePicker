//
//  ImagePreviewViewController.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit
import Stevia
import Combine

class ImagePreviewViewController: ViewController {
  let imageView = UIImageView()
  
  let viewModel: ImagePreviewViewModelProtocol
  
  var cancellables = Set<AnyCancellable>()
  
  init(viewModel: ImagePreviewViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Preview"
    
    imageView.image = viewModel.currentImage
    
    viewModel.onNewImage()
      .sink { [weak self] _ in
        self?.showNextImage()
      }
      .store(in: &cancellables)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.start()
  }
  
  override func prepareSubviews() {
    view.sv(imageView)
  }
  
  override func setConstraints() {
    imageView.width(300).height(300)
    imageView.centerInContainer()
  }
  
  func showNextImage() {
    UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve) {
      self.imageView.image = self.viewModel.currentImage
    }
  }
}
