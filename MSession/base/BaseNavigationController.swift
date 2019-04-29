//
//  BaseNavigationController.swift
//  MSession
//
//  Created by Vitor Mesquita on 15/07/2018.
//

import UIKit

class BaseNavigationController: UINavigationController {
   
   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      navigationBar.tintColor = .white
      navigationBar.isTranslucent = false
      navigationBar.barTintColor = .primary
      navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
   }
   
   deinit {
      print("dealloc ---> \(String(describing: type(of: self)))")
   }
}
