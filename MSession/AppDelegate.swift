//
//  AppDelegate.swift
//  MSession
//
//  Created by Vitor Mesquita on 03/07/2018.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      let window = UIWindow()
      let mainNavigation = BaseNavigationController(rootViewController: LoginViewController())
      window.rootViewController = mainNavigation
      self.window = window
      self.window?.makeKeyAndVisible()
      
      return true
   }
}

