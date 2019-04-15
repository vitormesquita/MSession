//
//  SessionUtils.swift
//  MSession
//
//  Created by Vitor Mesquita on 15/07/2018.
//

import UIKit

public typealias MSession = (secretKey: String, user: AnyObject)

// MARK: - Enums

public enum SessionState: Equatable {
   case none
   case expired
   case runnig
}

public enum SessionDataStoreError: Error {
   case noSessionToUpdate
   case errorToCreateSession
}

// MARK: - Protocols

public protocol SessionDataStoreProtocol {
   func getSession<T: AnyObject>(type: T.Type) -> MSession?
   func createSession<T: AnyObject>(secretKey: String?, user: T?) throws -> MSession
   func updateSession<T: AnyObject>(secretKey: String?, user: T?) throws -> MSession
   func deleteSession()
}

public protocol SessionManagerDelegate: class {
   func sessionStateDidChange(_ state: SessionState)
}

enum MSessionKeys: String {
   case user = "m_session_user"
   case secretKey = "m_session_secret_key"
}
