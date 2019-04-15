//
//  KeyedArchiverManager.swift
//  MSession
//
//  Created by Vitor Mesquita on 15/07/2018.
//

import Foundation

class KeyedArchiverManager: NSObject {
   
   static func saveObjectWith(key: String, object: Any?) {
      var data: Data? = nil
      
      if let object = object {
         data = NSKeyedArchiver.archivedData(withRootObject: object) as Data?
      }
      
      UserDefaults.standard.set(data, forKey: key)
      UserDefaults.standard.synchronize()
   }
   
   static func retrieveObjectWith<T: Any>(key: String, type: T.Type) -> T? {
      guard let data = UserDefaults.standard.object(forKey: key) as? Data,
         let object = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? T else {
            return nil
      }
      
      return object
   }
   
   static func saveString(key: String, value: String?) {
      let data = value?.data(using: .utf8)
      UserDefaults.standard.set(data, forKey: key)
      UserDefaults.standard.synchronize()
   }
   
   static func retrieveStringWith(key: String) -> String? {
      guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
         return nil
      }
      
      return String(data: data, encoding: .utf8)
   }
}
