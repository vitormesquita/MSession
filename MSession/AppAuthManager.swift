//
//  AppAuthManager.swift
//  MSession
//
//  Created by Vitor Mesquita on 10/04/19.
//

import UIKit

class AppAuthManager: AuthManager {
   
   static let shared = AppAuthManager(serviceName: "AppServiceName")
   
   var biometryIsEnable: Bool {
      guard #available(iOS 11.0, *) else { return false }
      return self.biometryIsAvailable()
   }
}
