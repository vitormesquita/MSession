//
//  SessionDataStore.swift
//  MSession
//
//  Created by Vitor Mesquita on 03/07/2018.
//

import Foundation

class SessionDataStore: SessionDataStoreProtocol {
   
   private func saveCurrentSession(_ session: Session?) {
      KeyedArchiverManager.saveObjectWith(key: MSessionKeys.session.rawValue, object: session)
   }
   
   func getSession() -> Session? {
      return KeyedArchiverManager.retrieveObjectWith(key: MSessionKeys.session.rawValue, type: Session.self)
   }
   
   func createSession(accessToken: String?, user: MUser?) throws -> Session {
      guard let accessToken = accessToken, let user = user else {
         throw SessionDataStoreError.errorToCreateSession
      }
      
      let newSession = Session(user: user, accessToken: accessToken)
      saveCurrentSession(newSession)
      return newSession
   }
   
   func updateSession(accessToken: String?, user: MUser?) throws -> Session {
      guard let session = getSession() else {
         throw SessionDataStoreError.noSessionToUpdate
      }
      
      let updatedSession = Session(user: user ?? session.user, accessToken: accessToken ?? session.accessToken)
      saveCurrentSession(updatedSession)
      return updatedSession
   }
   
   func deleteSession() {
      saveCurrentSession(nil)
   }
}
