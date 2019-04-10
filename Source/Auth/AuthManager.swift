//
//  AuthManager.swift
//  MSession
//
//  Created by Vitor Mesquita on 09/04/19.
//

import UIKit

class AuthManager: NSObject {
   
   private var serviceName: String
   private var accessGroup: String?
   private var biometricAuth: BiometricAuthProtocol?
   
   public init(serviceName: String, accessGroup: String? = nil) {
      self.serviceName = serviceName
      self.accessGroup = accessGroup
      super.init()
      
      if #available(iOS 11.0, *) {
         self.biometricAuth = BiometricAuth()
         self.setBiometricEnable(true)
      }
   }
   
   /// Get all saved kaychain passwords and transform in `MAccount`
   private func getSavedAccounts() throws -> [MAccount] {
      let passwordItems = try KeychainPasswordItem.passwordItems(forService: self.serviceName, accessGroup: self.accessGroup)
      var accounts = [MAccount]()
      
      for item in passwordItems {
         do {
            let password = try item.readPassword()
            accounts.append((account: item.account, password: password))
         } catch {
            continue
         }
      }
      
      return accounts
   }
}

extension AuthManager {
   
   /// Set if your application can use biometric authentication
   /// Normally on sign in the user can set if want use biometric authentication or not
   @available(iOS 11.0, *)
   public func setBiometricEnable(_ isEnable: Bool) {
      UserDefaults.standard.set(isEnable, forKey: MAuthKeys.biometric.rawValue)
   }
   
   /// Return a flag if biometric is available
   @available(iOS 11.0, *)
   public func biometricIsAvailable() -> Bool {
      return (biometricAuth?.canEvaluatePolicy() ?? false) && UserDefaults.standard.bool(forKey: MAuthKeys.biometric.rawValue)
   }
   
   /// Call Face/Touch ID
   /// - Parameters:
   ///   - reason: Tell a reason why you want use Face/Touch ID authentication
   ///   - completion: Block to handle if has authentication or an error
   @available(iOS 11.0, *)
   public func biometricAuthentication(reason: String, completion: @escaping ((BiometricError?) -> Void)) {
      guard biometricIsAvailable() else {
         completion(BiometricError.notAvailable)
         return
      }
      
      biometricAuth?.authenticateUser(reason: reason, completion: completion)
   }
}

// MARK: - Keychain handler
extension AuthManager {
   
   /// Get all saved kaychain passwords
   /// - parameter completion: Block to return an Array of `MAccount` or an error
   public func getSavedAccounts(completion: @escaping (([MAccount], Error?) -> Void)) {
      do {
         let items = try getSavedAccounts()
         completion(items, nil)
      } catch(let error) {
         completion([], error)
      }
   }
   
   /// Saved a account, KeychainPasswordItem trys to update a saved account or create new one
   /// - Parameters:
   ///   - account: An account like email, username or something like that
   ///   - password: Password to be saved
   ///   - completion: Block to handle if it returns an error and cannot saved this Account
   public func saveAccount(account: String, password: String, completion: ((Error?) -> Void)) {
      do {
         let keychain = KeychainPasswordItem(service: self.serviceName, account: account, accessGroup: self.accessGroup)
         try keychain.savePassword(password)
         completion(nil)
         
      } catch(let error) {
         completion(error)
      }
   }
   
   /// Get all saved kaychain passwords with biometric authentication
   /// - Parameters:
   ///   - reason: Tell a reason why you want use Face/Touch ID authentication
   ///   - completion: Block to return an Array of `MAccount` or an error
   @available(iOS 11.0, *)
   public func getSavedAccountsWithBiometric(reason: String, completion: @escaping (([MAccount], Error?) -> Void)) {
      biometricAuthentication(reason: reason) { (error) in
         guard error == nil else {
            completion([], error)
            return
         }
         
         self.getSavedAccounts(completion: completion)
      }
   }
}
