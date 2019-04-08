//
//  Utils.swift
//  MSession
//
//  Created by Vitor Mesquita on 15/07/2018.
//

import UIKit

public typealias MUser = NSObject & NSCoding
public typealias MAccount = (account: String, password: String)

// MARK: - Enuns

public enum SessionState: Equatable {
   case none
   case expired
   case runnig(Session)
}

public enum SessionDataStoreError: Error {
   case noSessionToUpdate
   case errorToCreateSession
}

public enum BiometricError: Error {
   case notAvailable
   case failed
   case userCancel
   case userFallback
   case notEnrolled
   case lockout
   case notConfigured
}

public enum KeychainError: Error {
   case noPassword
   case unexpectedPasswordData
   case unexpectedItemData
   case unhandledError(status: OSStatus)
}

// MARK: - Protocols

public protocol SessionDataStoreProtocol {
   func getSession() -> Session?
   func createSession(accessToken: String?, user: MUser?) throws -> Session
   func updateSession(accessToken: String?, user: MUser?) throws -> Session
   func deleteSession()
}

public protocol SessionManagerDelegate: class {
   func sessionStateDidChange(_ state: SessionState)
}

enum MKeys: String {
   case session = "m_session_key"
   case biometric = "m_session_biometric_enable"
}
