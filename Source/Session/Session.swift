//
//  Session.swift
//  MSession
//
//  Created by Vitor Mesquita on 03/07/2018.
//

import UIKit

open class Session: NSObject, NSCoding {
   
   public let user: MUser
   public let accessToken: String
   
   init(user: MUser, accessToken: String) {
      self.user = user
      self.accessToken = accessToken
   }
   
   required convenience public init?(coder aDecoder: NSCoder) {
      if let user = aDecoder.decodeObject(forKey: MSessionKeys.user.rawValue) as? MUser,
         let accessToken = aDecoder.decodeObject(forKey: MSessionKeys.acessToken.rawValue) as? String {
         self.init(user: user, accessToken: accessToken)
      } else {
         return nil
      }
   }
   
   public func encode(with aCoder: NSCoder) { 
      aCoder.encode(user, forKey: MSessionKeys.user.rawValue)
      aCoder.encode(accessToken, forKey: MSessionKeys.acessToken.rawValue)
   }
}
