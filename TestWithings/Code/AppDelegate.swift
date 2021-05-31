//
//  AppDelegate.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let worker = ImageWorker()
  var cancellables = Set<AnyCancellable>()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    configureWindow()
    
    return true
  }
}

