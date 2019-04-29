//
//  User.swift
//  MSession
//
//  Created by Vitor Mesquita on 15/07/2018.
//

import UIKit

class User: NSObject, NSCoding {
   
   let id: Int
   let name: String
   let email: String
   
   init(id: Int, name: String, email: String) {
      self.id = id
      self.name = name
      self.email = email
      super.init()
   }
   
   convenience required init?(coder aDecoder: NSCoder) {
      let id = aDecoder.decodeInteger(forKey: "user_id")
      
      if let name = aDecoder.decodeObject(forKey: "user_name") as? String,
         let email = aDecoder.decodeObject(forKey: "user_email") as? String {
         
         self.init(id: id, name: name, email: email)
         
      } else {
         return nil
      }
   }
   
   func encode(with aCoder: NSCoder) {
      aCoder.encode(id, forKey: "user_id")
      aCoder.encode(name, forKey: "user_name")
      aCoder.encode(email, forKey: "user_email")
   }
}
