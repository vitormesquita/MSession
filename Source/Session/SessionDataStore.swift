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
      self.keychain = Keychain(service: service, prefix: "msession")
   }
   
   /// Save current session on keychain
   /// - parameter secretKey: a secretkey to authenticate user normally on server like a token
   /// - parameter user: Represents a user object to save on session
   private func saveCurrentSession<T: AnyObject>(secretKey: String, user: T) throws -> MSession {
      guard let data = NSKeyedArchiver.archivedData(withRootObject: user) as Data? else {
         throw SessionDataStore.Error.archivedDataFailed
      }
      
      let secretKeychain = keychain.getOrCreateItemBy(account: MSessionKeys.secretKey.rawValue)
      try secretKeychain.set(string: secretKey)
      
      let userKeychain = keychain.getOrCreateItemBy(account: MSessionKeys.user.rawValue)
      try userKeychain.set(data: data)
      
      return MSession(secretKey, user)
   }
   
   /// Create session and return `MSession`, can send throw if parameters are not correct
   public func createSession<T>(secretKey: String?, user: T?) throws -> MSession where T : AnyObject {
      guard let secretKey = secretKey, let user = user else {
         throw SessionDataStore.Error.errorToCreateSession
      }
      
      let newSession = try saveCurrentSession(secretKey: secretKey, user: user)
      return newSession
   }
   
   /// Update session if has a session to be updated
   public func updateSession<T>(secretKey: String?, user: T?) throws -> MSession where T : AnyObject {
      guard let session = getSession(type: T.self) else {
         throw SessionDataStore.Error.noSessionToUpdate
      }
      
      let updatedSession = try saveCurrentSession(secretKey: secretKey ?? session.secretKey, user: user ?? session.user)
      return updatedSession
   }
   
   /// Retrieve session saved on keychain and return as `MSession`
   public func getSession<T: AnyObject>(type: T.Type) -> MSession? {
      guard let secretKeychain = keychain.getItemBy(account: MSessionKeys.secretKey.rawValue),
         let userKeychain = keychain.getItemBy(account: MSessionKeys.user.rawValue) else {
            return nil
      }
      
      guard let secretKey = try? secretKeychain.getString(),
         let userData = try? userKeychain.getData(),
         let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? T else {
            return nil
      }
      
      return MSession(secretKey, user)
   }
   
   /// Delete session items saved on keychain
   public func deleteSession() {
      guard let secretKeychain = keychain.getItemBy(account: MSessionKeys.secretKey.rawValue),
         let userKeycahin = keychain.getItemBy(account: MSessionKeys.user.rawValue) else {
            return
      }
      
      try? secretKeychain.deleteItem()
      try? userKeycahin.deleteItem()
   }
}
