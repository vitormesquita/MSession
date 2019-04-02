//
//  SessionManager.swift
//  MSession
//
//  Created by Vitor Mesquita on 05/07/2018.
//

import Foundation

open class SessionManager<T: MUser>: NSObject {
   
   // MARK: private
   private let sessionDataStore: SessionDataStoreProtocol
   private let biometricAuth = BiometricAuth()
   
   private var cachedSession: Session? {
      didSet {
         if let cachedSession = cachedSession {
            state = .runnig(cachedSession)
         }
      }
   }
   
   private var state: SessionState {
      didSet {
         if state != oldValue {
            delegate?.sessionStateDidChange(state)
         }
      }
   }
   
   // MARK: public
   public weak var delegate: SessionManagerDelegate?
   
   public init(sessionDataStore: SessionDataStoreProtocol) {
      self.sessionDataStore = sessionDataStore
      
      if let session = sessionDataStore.getSession() {
         self.state = .runnig(session)
      } else {
         self.state = .none
      }
      
      super.init()
   }
   
   public override init() {
      self.sessionDataStore = SessionDataStore()
      
      if let session = sessionDataStore.getSession() {
         self.state = .runnig(session)
      } else {
         self.state = .none
      }
      
      super.init()
   }
   
   private func deleteSession() {
      sessionDataStore.deleteSession()
      cachedSession = nil
   }
}

extension SessionManager {
   
   /// Return user in session if it's running
   public var user: T? {
      return session?.user as? T
   }
   
   /// Return the secret key to auth user
   public var secretKey: String? {
      return session?.accessToken
   }
   
   /// Return session cached if has or get saved session and put in cache
   public var session: Session? {
      guard let cachedSession = cachedSession else {
         self.cachedSession = sessionDataStore.getSession()
         return self.cachedSession
      }
      
      return cachedSession
   }
   
   /// Create session on your app
   /// - Parameters:
   ///     - secretKey: Secret Key returned through webservice after authentication (token or hashs) to validate requests on webservice
   ///     - user: User returned through webservice after authentication that session needs to be created
   public func createSession(secretKey: String?, user: T?) throws {
      cachedSession = try? sessionDataStore.createSession(accessToken: secretKey, user: user)
   }
   
   /// Update session on your app
   /// - Parameters:
   ///     - secretKey: If return `nil` will user old value saved
   ///     - user: If return `nil` will user old value saved
   public func updateSession(secretKey: String?, user: T?) throws {
      cachedSession = try? sessionDataStore.updateSession(accessToken: secretKey, user: user)
   }
   
   /// Delete session and put the sessionState as expired
   public func expireSession() {
      deleteSession()
      state = .expired
   }
   
   /// Delete session and put the state as none
   public func logout() {
      deleteSession()
      state = .none
   }
}

extension SessionManager {
   
   ///
   public func setBiometricEnable(_ isEnable: Bool) {
      UserDefaults.standard.set(isEnable, forKey: MKeys.biometric.rawValue)
   }
   
   ///
   public func biometricIsAvailable() -> Bool {
      return biometricAuth.canEvaluatePolicy() && UserDefaults.standard.bool(forKey: MKeys.biometric.rawValue)
   }
   
   ///
   public func biometricAuthentication(reason: String, completion: @escaping ((BiometricError?) -> Void)) {
      return biometricAuth.authenticateUser(reason: reason, completion: completion)
   }
   
   ///
   public func authenticate(reason: String, completion: @escaping ((MAccount?, Error?) -> Void)) {
      biometricAuthentication(reason: reason) { (error) in
         //TODO
      }
   }
}
