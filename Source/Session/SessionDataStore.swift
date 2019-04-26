//
//  SessionDataStore.swift
//  MSession
//
//  Created by Vitor Mesquita on 03/07/2018.
//

import Foundation

public class SessionDataStore: SessionDataStoreProtocol {
   
   public enum Error: Swift.Error {
      case archivedDataFailed
      case noSessionToUpdate
      case errorToCreateSession
   }
   
   private let keychain: Keychain
   
   init(service: String) {
      self.keychain = Keychain(service: service)
   }
   
   ///
   private func saveCurrentSession<T: AnyObject>(secretKey: String, user: T) throws -> MSession {
      guard let data = NSKeyedArchiver.archivedData(withRootObject: user) as Data? else {
         throw SessionDataStore.Error.archivedDataFailed
      }
      
      let secretKeychain = keychain.getOrCreateItemBy(account: MSessionKeys.secretKey.rawValue)
      try secretKeychain.set(string: secretKey)
      
      let userKeychain = keychain.getOrCreateItemBy(account: secretKey)
      try userKeychain.set(data: data)
      
      return MSession(secretKey, user)
   }
   
   ///
   public func createSession<T>(secretKey: String?, user: T?) throws -> MSession where T : AnyObject {
      guard let secretKey = secretKey, let user = user else {
         throw SessionDataStore.Error.errorToCreateSession
      }
      
      let newSession = try saveCurrentSession(secretKey: secretKey, user: user)
      return newSession
   }
   
   ///
   public func updateSession<T>(secretKey: String?, user: T?) throws -> MSession where T : AnyObject {
      guard let session = getSession(type: T.self) else {
         throw SessionDataStore.Error.noSessionToUpdate
      }
      
      let updatedSession = try saveCurrentSession(secretKey: secretKey ?? session.secretKey, user: user ?? session.user)
      return updatedSession
   }
   
   ///
   public func getSession<T: AnyObject>(type: T.Type) -> MSession? {
      guard let secretKeychain = keychain.getItemBy(account: MSessionKeys.secretKey.rawValue) else {
         return nil
      }
      
      guard let secretKey = try? secretKeychain.getString(),
         let userKeychain = keychain.getItemBy(account: secretKey),
         let userData = try? userKeychain.getData(),
         let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? T else {
            return nil
      }
      
      return MSession(secretKey, user)
   }
   
   ///
   public func deleteSession() {
      guard let secretKeychain = keychain.getItemBy(account: MSessionKeys.secretKey.rawValue),
         let secretKey = try? secretKeychain.getString() else {
            return
      }
      
      guard let userKeycahin = keychain.getItemBy(account: secretKey) else {
         return
      }
      
      try? secretKeychain.deleteItem()
      try? userKeycahin.deleteItem()
   }
}
