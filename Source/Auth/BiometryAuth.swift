//
//  BiometricAuth.swift
//  MSession
//
//  Created by Vitor Mesquita on 02/04/19.
//

import LocalAuthentication

protocol BiometryAuthProtocol {
   func canEvaluatePolicy() -> Bool
   func biometryType() -> BiometryType
   func authenticateUser(reason: String, completion: @escaping (BiometryError?) -> Void)
}

class BiometryAuth: BiometryAuthProtocol {
   
   private let context = LAContext()
   
   func canEvaluatePolicy() -> Bool {
      guard #available(iOS 11.0, *) else { return false }
      return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
   }
   
   func biometryType() -> BiometryType {
      let _ = canEvaluatePolicy()
      
      guard #available(iOS 11.0, *) else { return .none }
      
      switch context.biometryType {
      case .none:
         return .none
      case .faceID:
         return .faceID
      case .touchID:
         return .touchID
      @unknown default:
         return .none
      }
   }
   
   func authenticateUser(reason: String, completion: @escaping (BiometryError?) -> Void) {
      guard canEvaluatePolicy() else {
         completion(.notAvailable)
         return
      }
      
      guard #available(iOS 11.0, *) else { return }
      
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, evaluateError) in
         DispatchQueue.main.async {
            guard !success else {
               completion(nil)
               return
            }
            
            let error: BiometryError?
            switch evaluateError {
            case LAError.authenticationFailed?:
               error = .failed
            case LAError.userCancel?:
               error = .userCancel
            case LAError.userFallback?:
               error = .userFallback
            case LAError.biometryNotAvailable?:
               error = .notAvailable
            case LAError.biometryNotEnrolled?:
               error = .notEnrolled
            case LAError.biometryLockout?:
               error = .lockout
            default:
               error = .notConfigured
            }
            
            completion(error)            
         }
      }
   }
}
