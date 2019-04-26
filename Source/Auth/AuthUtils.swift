//
//  AuthUtils.swift
//  MSession
//
//  Created by Vitor Mesquita on 10/04/19.
//

import Foundation

public typealias MAccount = (account: String, password: String)

// MARK: - Enums

public enum BiometryType {
   case none
   case faceID
   case touchID
}

public enum BiometryError: Error {
   case notAvailable
   case failed
   case userCancel
   case userFallback
   case notEnrolled
   case lockout
   case notConfigured
}

enum MAuthKeys: String {
   case biometric = "m_session_biometric_enable"
}
