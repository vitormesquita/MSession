//
//  SessionDataStore.swift
//  MSession
//
//  Created by Vitor Mesquita on 03/07/2018.
//

import Foundation

class SessionDataStore: SessionDataStoreProtocol {
   
   private func saveCurrentSession<T: AnyObject>(secretKey: String, user: T) -> MSession {
      KeyedArchiverManager.saveObjectWith(key: MSessionKeys.user.rawValue, object: user)
      KeyedArchiverManager.saveString(key: MSessionKeys.secretKey.rawValue, value: secretKey)
      
      return MSession(secretKey, user)
   }
   
   func getSession<T: AnyObject>(type: T.Type) -> MSession? {
      guard let secretKey = KeyedArchiverManager.retrieveStringWith(key: MSessionKeys.secretKey.rawValue),
         let user = KeyedArchiverManager.retrieveObjectWith(key: MSessionKeys.user.rawValue, type: type) else {
            return nil
      }
      
      return MSession(secretKey, user)
   }
   
   func createSession<T>(secretKey: String?, user: T?) throws -> MSession where T : AnyObject {
      guard let secretKey = secretKey, let user = user else {
         throw SessionDataStoreError.errorToCreateSession
      }
      
      let newSession = saveCurrentSession(secretKey: secretKey, user: user)
      return newSession
   }
   
   func updateSession<T>(secretKey: String?, user: T?) throws -> MSession where T : AnyObject {
      guard let session = getSession(type: T.self) else {
         throw SessionDataStoreError.noSessionToUpdate
      }
      
      let updatedSession = saveCurrentSession(secretKey: secretKey ?? session.secretKey, user: user ?? session.user)
      return updatedSession
   }
   
   func deleteSession() {
      KeyedArchiverManager.saveObjectWith(key: MSessionKeys.user.rawValue, object: nil)
      KeyedArchiverManager.saveString(key: MSessionKeys.secretKey.rawValue, value: nil)
   }
}
