//
//  AppSessionManager.swift
//  MSession
//
//  Created by Vitor Mesquita on 11/04/19.
//

import UIKit

class AppSessionManager: SessionManager<User> {
   
   static let shared = AppSessionManager(expireTime: 300)
   
   private let expireTime: TimeInterval
   private var statesBlock: [String: ((SessionState) -> Void)] = [:]
   
   init(expireTime: TimeInterval) {
      self.expireTime = expireTime
      super.init()
      delegate = self
   }
   
   override func createSession(secretKey: String?, user: User?) throws {
      UserDefaults.standard.set(Date().addingTimeInterval(expireTime), forKey: "expire_date")
      try super.createSession(secretKey: secretKey, user: user)
   }
   
   func appendedStateBlock(key: String, block: @escaping ((SessionState) -> Void)) {
      statesBlock[key] = block
   }
   
   func removeStateBlockWith(key: String) {
      statesBlock.removeValue(forKey: key)
   }
   
   func verifyExpireDate() {
      guard let date = UserDefaults.standard.object(forKey: "expire_date") as? Date else { return }
      
      if date < Date() {
         self.expireSession()
      }
   }
}

extension AppSessionManager: SessionManagerDelegate {
   
   func sessionStateDidChange(_ state: SessionState) {
      statesBlock.values.forEach { (block) in
         block(state)
      }
   }
}
