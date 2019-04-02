//
//  SessionDataStore.swift
//  MSession
//
//  Created by Vitor Mesquita on 03/07/2018.
//

import Foundation

class SessionDataStore: SessionDataStoreProtocol {
   
   private let mSessionKey = "m_session_key"
   private func saveCurrentSession(_ session: Session?) {
      KeyedArchiverManager.saveObjectWith(key: mSessionKey, object: session)
   }
   
   func getSession() -> Session? {
      return KeyedArchiverManager.retrieveObjectWith(key: mSessionKey, type: Session.self)
   }
   
   func createSession(accessToken: String?, user: MUser?) throws -> Session {
      guard let accessToken = accessToken, let user = user else {
         throw SessionDataStoreError.errorToCreateSession
      }
      
      let newSession = Session(accessToken: accessToken, user: user)
      saveCurrentSession(newSession)
      return newSession
   }
   
   func updateSession(accessToken: String?, user: MUser?) throws -> Session {
      guard let session = getSession() else {
         throw SessionDataStoreError.noSessionToUpdate
      }
      
      let updatedSession = Session(accessToken: accessToken ?? session.accessToken, user: user ?? session.user)
      saveCurrentSession(updatedSession)
      return updatedSession
   }
   
   func deleteSession() {
      saveCurrentSession(nil)
   }
}
