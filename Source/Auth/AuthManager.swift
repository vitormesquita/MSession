//
//  AuthManager.swift
//  MSession
//
//  Created by Vitor Mesquita on 09/04/19.
//

import Foundation

open class AuthManager: NSObject {
   
   public enum Error: Swift.Error {
      case blankInformations
      case notFoundAccount
   }
   
   private let keychain: Keychain
   private let biometryAuth: BiometryAuthProtocol
   
   public init(service: String, accessGroup: String? = nil) {
      self.biometryAuth = BiometryAuth()
      self.keychain = Keychain(service: service, accessGroup: accessGroup)
      super.init()
   }
   
   /// Delete all saved accounts excluding accounts passing as parameters
   private func deleteSavedAccountsExclude(accounts: [String]) {
      do {
         let passwordItems = try keychain.items()
         
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
   
   /// Return biometry type the device has Face ID or Touch ID
   public var biometryType: BiometryType {
      return biometryAuth.biometryType()
   }
   
   /// Inform if your application can use biometry authentication automatically
   /// Normally on sign in the user can set if want use biometric authentication
   public var automaticallyBiometryAuth: Bool {
      get { return UserDefaults.standard.bool(forKey: MAuthKeys.biometric.rawValue) }
      set { UserDefaults.standard.set(newValue, forKey: MAuthKeys.biometric.rawValue) }
   }
   
   /// Return a flag if biometric is available
   open func biometryIsAvailable() -> Bool {
      return biometryAuth.canEvaluatePolicy()
   }
   
   /// Call Face/Touch ID
   /// - Parameters:
   ///   - reason: Tell a reason why you want use Face/Touch ID authentication
   ///   - completion: Closure to handle if was authenticated or had an error
   open func biometryAuthentication(reason: String, completion: @escaping ((BiometryError?) -> Void)) {
      guard biometryIsAvailable() else {
         completion(BiometryError.notAvailable)
         return
      }
      
      biometryAuth.authenticateUser(reason: reason, completion: completion)
   }
}

// MARK: - Keychain handler
extension AuthManager {
   
   /// Get all saved keychain passwords and transform in `MAccount`
   open func getSavedAccounts() throws -> [MAccount] {
      let passwordItems = try keychain.items()
      var accounts = [MAccount]()
      
      for item in passwordItems {
         do {
            let password = try item.getString()
            accounts.append((account: item.account, password: password))
         } catch {
            continue
         }
      }
      
      return accounts
   }
   
   /// Saved a account, KeychainPasswordItem trys to update a saved account or create new one
   /// - Parameters:
   ///   - account: An account like email, username or something like that
   ///   - password: Password to be saved
   ///   - deleteOthers: Flag to delete the others passwords
   open func saveAccount(account: String, password: String, deleteOthers: Bool = false) throws {
      guard !account.isEmpty && !password.isEmpty else {
         throw AuthManager.Error.blankInformations
      }
      
      let keychainItem = keychain.getOrCreateItemBy(account: account)
      try keychainItem.set(string: password)
      
      if deleteOthers {
         self.deleteSavedAccountsExclude(accounts: [account])
      }
   }
   
   /// Rename a saved account, if there aren't any account will send a throw
   /// - Parameters:
   ///   - account: A old account to find on Keychain
   ///   - newAccount: New account to be saved and keep the old password
   open func renameAccount(_ account: String, newAccount: String) throws {
      guard !newAccount.isEmpty else {
         throw AuthManager.Error.blankInformations
      }
      
      guard var keychainItem = keychain.getItemBy(account: account) else {
         throw AuthManager.Error.notFoundAccount
      }
      
      try keychainItem.renameAccount(newAccount)
   }
   
   /// Delete all accounts saved on keychain
   open func deleteAllAccounts() {
      deleteSavedAccountsExclude(accounts: [])
   }
   
   /// Get all saved keychain passwords with biometric authentication
   /// - Parameters:
   ///   - reason: Tell a reason why you want use Face/Touch ID authentication
   ///   - completion: Closure to return an Array of `MAccount` or an error
   open func getSavedAccountsWithBiometric(reason: String, completion: @escaping (([MAccount], Swift.Error?) -> Void)) {
      biometryAuthentication(reason: reason) { (error) in
         guard error == nil else {
            completion([], error)
            return
         }
         
         do {
          let items = try self.getSavedAccounts()
            completion(items, nil)
         } catch(let error) {
            completion([], error)
         }
      }
   }
}
