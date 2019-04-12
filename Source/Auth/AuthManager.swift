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
   private var biometryAuth: BiometryAuthProtocol?
   
   public init(serviceName: String, accessGroup: String? = nil) {
      self.serviceName = serviceName
      self.accessGroup = accessGroup
      super.init()
      
      if #available(iOS 11.0, *) {
         self.biometryAuth = BiometryAuth()
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
   
   /// Delete all saved accounts excluding accounts passing as parameters
   private func deleteSavedAccountsExclude(accounts: [String]) {
      do {
         let passwordItems = try KeychainPasswordItem.passwordItems(forService: self.serviceName, accessGroup: self.accessGroup)
         
         for item in passwordItems {
            guard !accounts.contains(item.account) else { continue }
            try item.deleteItem()
         }
         
      } catch(let error) {
         print(error.localizedDescription)
      }
   }
}

extension AuthManager {
   
   ///
   var biometryType: BiometryType {
      return biometryAuth?.biometryType() ?? .none
   }
   
   /// Inform if your application can use biometry authentication automatically and has any password saved on kaychain
   /// Normally on sign in the user can set if want use biometric authentication or not
   var automaticallyBiometryAuth: Bool {
      get { return UserDefaults.standard.bool(forKey: MAuthKeys.biometric.rawValue) }
      set { UserDefaults.standard.set(newValue, forKey: MAuthKeys.biometric.rawValue) }
   }
   
   /// Return a flag if biometric is available
   @available(iOS 11.0, *)
   public func biometryIsAvailable() -> Bool {
      return (biometryAuth?.canEvaluatePolicy() ?? false)
   }
   
   /// Call Face/Touch ID
   /// - Parameters:
   ///   - reason: Tell a reason why you want use Face/Touch ID authentication
   ///   - completion: Block to handle if has authentication or an error
   @available(iOS 11.0, *)
   public func biometryAuthentication(reason: String, completion: @escaping ((BiometryError?) -> Void)) {
      guard biometryIsAvailable() else {
         completion(BiometryError.notAvailable)
         return
      }
      
      biometryAuth?.authenticateUser(reason: reason, completion: completion)
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
   ///   - deleteOthers: Flag to delete the others passwords
   ///   - completion: Block to handle if it returns an error and cannot saved this Account
   public func saveAccount(account: String, password: String, deleteOthers: Bool = false, completion: ((Error?) -> Void)? = nil) {
      var completionError: Error?
      do {
         let keychain = KeychainPasswordItem(service: self.serviceName, account: account, accessGroup: self.accessGroup)
         try keychain.savePassword(password)
         
         if deleteOthers {
            self.deleteSavedAccountsExclude(accounts: [account])
         }
         
      } catch(let error) {
         completionError = error
      }
      
      guard let completion = completion else { return }
      completion(completionError)
   }
   
   /// Get all saved kaychain passwords with biometric authentication
   /// - Parameters:
   ///   - reason: Tell a reason why you want use Face/Touch ID authentication
   ///   - completion: Block to return an Array of `MAccount` or an error
   @available(iOS 11.0, *)
   public func getSavedAccountsWithBiometric(reason: String, completion: @escaping (([MAccount], Error?) -> Void)) {
      biometryAuthentication(reason: reason) { (error) in
         guard error == nil else {
            completion([], error)
            return
         }
         
         self.getSavedAccounts(completion: completion)
      }
   }
}
