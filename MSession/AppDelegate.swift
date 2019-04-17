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
   
   private var dashboardVC: UIViewController {
      return BaseNavigationController(rootViewController: DashboardViewController())
   }
   
   private var loginVC: UIViewController {
      return BaseNavigationController(rootViewController: LoginViewController(nibName: "LoginViewController", bundle: nil))
   }
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      let window = UIWindow()
      let rootVC: UIViewController
      
      AppSessionManager.shared.verifyExpireDate()
      
      if let _ = AppSessionManager.shared.session {
         rootVC = dashboardVC
      } else {
         rootVC = loginVC
      }
      
      window.rootViewController = rootVC
      self.window = window
      self.window?.makeKeyAndVisible()
      
      observeSessionState()
      
      return true
   }
   
   func applicationWillEnterForeground(_ application: UIApplication) {
      AppSessionManager.shared.verifyExpireDate()
   }
   
   func observeSessionState() {
      AppSessionManager.shared.appendedStateBlock(key: "session_state") {[weak self] (state) in
         guard let self = self else { return }
         switch state {
         case .running:
            self.replaceRootViewControllerTo(viewController: self.dashboardVC)
         default:
            self.replaceRootViewControllerTo(viewController: self.loginVC)
         }
      }
   }
   
   func replaceRootViewControllerTo(viewController: UIViewController) {
      guard let window = window else { return }
      UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
         window.rootViewController = viewController
      })
   }
}

