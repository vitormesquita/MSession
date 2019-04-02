//
//  KeyedArchiverManager.swift
//  MSession
//
//  Created by Vitor Mesquita on 15/07/2018.
//

import Foundation

class KeyedArchiverManager: NSObject {
   
   static func saveObjectWith(key: String, object: NSObject?) {
      let data: Data?
      if let object = object {
         data = NSKeyedArchiver.archivedData(withRootObject: object) as Data?
      }else {
         data = nil
      }
      UserDefaults.standard.set(data, forKey: key)
      UserDefaults.standard.synchronize()
   }
   
   static func retrieveObjectWith<T: NSObject>(key: String, type: T.Type) -> T? {
      if let data = UserDefaults.standard.object(forKey: key) as? Data,
         let object = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? T {
         return object
      }
      return nil
   }
}
