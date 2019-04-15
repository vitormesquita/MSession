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
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
            
      print(AppSessionManager.shared.secretKey ?? "")
      print(AppSessionManager.shared.user?.id ?? 0)
      print(AppSessionManager.shared.user?.name ?? "")
      print(AppSessionManager.shared.user?.email ?? "")
   }
   
   @objc func logoutDidTap() {
      AppSessionManager.shared.logout()
   }
}
