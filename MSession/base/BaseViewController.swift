//
//  BaseViewController.swift
//  MSession
//
//  Created by Vitor Mesquita on 15/07/2018.
//

import UIKit

class BaseViewController: UIViewController {
   
   override func loadView() {
      super.loadView()
      view.backgroundColor = .white
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   deinit {
      print("dealloc ---> \(String(describing: type(of: self)))")
   }
}
