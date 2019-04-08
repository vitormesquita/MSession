//
//  SessionManager+Auth.swift
//  MSession
//
//  Created by Vitor Mesquita on 08/04/19.
//

import Foundation

// MARK: - Biometric handler
extension SessionManager {
   
   public convenience init(serviceName: String, accessGroup: String? = nil) {
      self.init()
      self.serviceName = serviceName
      self.accessGroup = accessGroup
      
      setBiometricEnable(true)
   }
   
   /// Set if your application can use biometric authentication
   /// Normally on sign in the user can set if want use biometric authentication or not
   public func setBiometricEnable(_ isEnable: Bool) {
      UserDefaults.standard.set(isEnable, forKey: MKeys.biometric.rawValue)
   }
   
   /// Return a flag if biometric is available
   public func biometricIsAvailable() -> Bool {
      return biometricAuth.canEvaluatePolicy() && UserDefaults.standard.bool(forKey: MKeys.biometric.rawValue)
   }
   
   /// Call Face/Touch ID
   /// - parameter reason: Tell a reason why you want use Face/Touch ID authentication
   /// - parameter completion: Block to handle if has authentication or an error
   public func biometricAuthentication(reason: String, completion: @escaping ((BiometricError?) -> Void)) {
      guard biometricIsAvailable() else {
         completion(BiometricError.notAvailable)
         return
      }
      
      biometricAuth.authenticateUser(reason: reason, completion: completion)
   }
}

// MARK: - Keychain handler
extension SessionManager {
   
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
   
   /// Get all saved kaychain passwords with biometric authentication
   /// - parameter reason: Tell a reason why you want use Face/Touch ID authentication
   /// - parameter completion: Block to return an Array of `MAccount` or an error
   public func getSavedAccountsWithBiometric(reason: String, completion: @escaping (([MAccount], Error?) -> Void)) {
      biometricAuthentication(reason: reason) { (error) in
         guard error == nil else {
            completion([], error)
            return
         }
         
         self.getSavedAccounts(completion: completion)
      }
   }
   
   /// Saved a account, KeychainPasswordItem trys to update a saved account or create new one
   /// - parameter account: An account like email, username or something like that
   /// - parameter password: Password to be saved
   /// - parameter completion: Block to handle if it returns an error and cannot saved this Account
   public func saveAccount(account: String, password: String, completion: ((Error?) -> Void)) {
      do {
         let keychain = KeychainPasswordItem(service: self.serviceName, account: account, accessGroup: self.accessGroup)
         try keychain.savePassword(password)
         completion(nil)
         
      } catch(let error) {
         completion(error)
      }
   }
}
