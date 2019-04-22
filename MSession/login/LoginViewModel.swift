//
//  LoginViewModel.swift
//  MSession
//
//  Created by Vitor Mesquita on 10/04/19.
//

import UIKit

protocol LoginViewModelProtocol {
   
   var biometryText: String? { get }
   var automaticallySigninIsEnable: Bool { get }
   var fieldsVisibility: ((Bool) -> Void)? { get set }
   
   func verifyAutoAuth()
   func signIn(email: String?, password: String?, biometry: Bool)
}

class LoginViewModel {
   
   var fieldsVisibility: ((Bool) -> Void)?
   
   private var isFieldsVisible: Bool = false {
      didSet {
         guard let formVisibility = fieldsVisibility else { return }
         formVisibility(isFieldsVisible)
      }
   }
}

extension LoginViewModel {
   
   private func loginWith(email: String, password: String) {
      if email == "mano@gmail.com" && password == "12345" {
         AppAuthManager.shared.saveAccount(account: email, password: password, deleteOthers: true)
         
         do {
            try AppSessionManager.shared.createSession(secretKey: "token", user: User(id: 0, name: "Mano", email: "mano@gmail.com"))
         } catch {
            //handler with error
         }
         
      } else {
         isFieldsVisible = true
      }
   }
   
   private func authenticate() {
      AppAuthManager.shared.getSavedAccountsWithBiometric(reason: "An reason that I don't know") {[weak self] (accounts, error) in
         guard let self = self else { return }
         self.isFieldsVisible = accounts.isEmpty || error != nil
         
         if error != nil {
            //handler with error
         }
         
         if let firstAccount = accounts.last {
            self.loginWith(email: firstAccount.account, password: firstAccount.password)
         }
      }
   }
}

extension LoginViewModel: LoginViewModelProtocol {
   
   var biometryText: String? {
      let type = AppAuthManager.shared.biometryType
      
      switch type {
      case .faceID:
         return "Login with Face ID"
      case .touchID:
         return "Login with Touch ID"
      default:
         return nil
      }
   }
   
   var automaticallySigninIsEnable: Bool {
      return AppAuthManager.shared.automaticallyBiometryAuth
   }
   
   func verifyAutoAuth() {
      guard AppAuthManager.shared.automaticallyBiometryAuth else {
         isFieldsVisible = true
         return
      }
      
      authenticate()
   }
   
   func signIn(email: String?, password: String?, biometry: Bool) {
      AppAuthManager.shared.automaticallyBiometryAuth = biometry
      
      guard let email = email, let password = password else {
         //handler with error
         return
      }
      
      loginWith(email: email, password: password)
   }
}
