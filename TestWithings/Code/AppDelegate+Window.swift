//
//  AppDelegate+Window.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit

extension AppDelegate {
  func configureWindow() {
    let coordinator = ImageFlowCoordinator()
    let viewController = SearchListViewController(coordinator: coordinator)
    let navigationController = UINavigationController(rootViewController: viewController)
    coordinator.rootViewController = navigationController
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.overrideUserInterfaceStyle = .light
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}
