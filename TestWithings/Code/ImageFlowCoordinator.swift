//
//  ImageFlowCoordinator.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit

class Coordinator {
  weak var rootViewController: UINavigationController?
}

protocol ImageFlowCoordinable {
  func showDetailView(for images: [UIImage])
}

class ImageFlowCoordinator: Coordinator, ImageFlowCoordinable {
  func showDetailView(for images: [UIImage]) {
    let viewModel = ImagePreviewViewModel(images: images)
    let viewController = ImagePreviewViewController(viewModel: viewModel)
    rootViewController?.pushViewController(viewController, animated: true)
  }
}
