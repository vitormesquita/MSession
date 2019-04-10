//
//  AuthUtils.swift
//  MSession
//
//  Created by Vitor Mesquita on 10/04/19.
//

import Foundation

public typealias MAccount = (account: String, password: String)

// MARK: - Enums

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

public enum BiometryType {
   case none
   case faceID
   case touchID
}

enum MAuthKeys: String {
   case biometric = "m_session_biometric_enable"
}
