//
//  DashboardViewController.swift
//  MSession
//
//  Created by Vitor Mesquita on 10/04/19.
//

import UIKit

class DashboardViewController: BaseViewController {
   
   private lazy var logoutBarButton: UIBarButtonItem = {
      return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.logoutDidTap))
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      title = "Dashboard"
      navigationItem.leftBarButtonItem = logoutBarButton
   }
   
   @objc func logoutDidTap() {
      AppSessionManager.shared.logout()
   }
}
