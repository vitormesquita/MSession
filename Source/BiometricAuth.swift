//
//  BiometricAuth.swift
//  MSession
//
//  Created by Vitor Mesquita on 02/04/19.
//

import LocalAuthentication

public enum BiometricError: Swift.Error {
   case notAvailable
   case failed
   case userCancel
   case userFallback
   case notEnrolled
   case lockout
   case notConfigured
}

class BiometricAuth {
   
   private let context = LAContext()
   
   func canEvaluatePolicy() -> Bool {
      return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
   }
   
   func biometricType() -> LABiometryType {
      let _ = canEvaluatePolicy()
      return context.biometryType
   }
   
   func authenticateUser(reason: String, completion: @escaping (BiometricError?) -> Void) {
      guard canEvaluatePolicy() else {
         completion(.notAvailable)
         return
      }
      
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, evaluateError) in
         DispatchQueue.main.async {
            if success {
               completion(nil)
            } else {
               let error: BiometricError?
               
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
}
