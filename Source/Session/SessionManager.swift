//
//  SessionManager.swift
//  MSession
//
//  Created by Vitor Mesquita on 05/07/2018.
//

import Foundation

open class SessionManager<T: AnyObject>: NSObject {
   
   // MARK: private
   private let sessionDataStore: SessionDataStoreProtocol
   
   private var cachedSession: MSession? {
      didSet {
         if cachedSession != nil {
            state = .running
         }
      }
   }
   
   // MARK: - Public
   
   public var state: SessionState {
      didSet {
         if state != oldValue {
            delegate?.sessionStateDidChange(state)
         }
      }
   }
   
   public weak var delegate: SessionManagerDelegate?
   
   public init(dataStore: SessionDataStoreProtocol) {
      self.sessionDataStore = dataStore
      
      if (sessionDataStore.getSession(type: T.self)) != nil {
         self.state = .running
      } else {
         self.state = .none
      }
      
      super.init()
   }
   
   public init(service: String) {
      self.sessionDataStore = SessionDataStore(service: service)
      
      if (sessionDataStore.getSession(type: T.self)) != nil {
         self.state = .running
      } else {
         self.state = .none
      }
      
      super.init()
   }
   
   /// Return user in session if it's running
   public var user: T? {
      return session?.user as? T
   }
   
   /// Return the secret key to auth user
   public var secretKey: String? {
      return session?.secretKey
   }
   
   /// Return session cached if has or get saved session and put in cache
   public var session: MSession? {
      guard let cachedSession = cachedSession else {
         self.cachedSession = sessionDataStore.getSession(type: T.self)
         return self.cachedSession
      }
      
      return cachedSession
   }
   
   /// Create session on your app
   /// - Parameters:
   ///     - secretKey: Secret Key returned through webservice after authentication (token or hashs) to validate requests on webservice
   ///     - user: User returned through webservice after authentication that session needs to be created
   open func createSession(secretKey: String?, user: T?) throws {
      cachedSession = try sessionDataStore.createSession(secretKey: secretKey, user: user)
   }
   
   /// Update session on your app
   /// - Parameters:
   ///     - secretKey: If return `nil` will user old value saved
   ///     - user: If return `nil` will user old value saved
   open func updateSession(secretKey: String? = nil, user: T? = nil) throws {
      cachedSession = try sessionDataStore.updateSession(secretKey: secretKey, user: user)
   }
   
   /// Delete session and set state to expired
   open func expireSession() {
      deleteSession()
      state = .expired
   }
   
   /// Delete session and set state to none
   open func logout() {
      deleteSession()
      state = .none
   }
   
   // MARK: - Private
   
   private func deleteSession() {
      sessionDataStore.deleteSession()
      cachedSession = nil
   }
}
