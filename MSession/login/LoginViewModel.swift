//
//  LoginViewModel.swift
//  MSession
//
//  Created by Vitor Mesquita on 10/04/19.
//

import UIKit

protocol LoginViewModelProtocol {
   
   var biometryEnable: Bool { get }
   var biometryText: String? { get }
   var automaticallySigninIsEnable: Bool { get }
   
   var formVisibility: ((Bool) -> Void)? { get set }
   
   func viewDidLoad()
   func signIn(email: String?, password: String?, biometry: Bool)
}

class LoginViewModel {
   
   var loggedIn: (() -> Void)?
   var formVisibility: ((Bool) -> Void)?
   
   private var formVisible: Bool = false {
      didSet {
         guard let formVisibility = formVisibility else { return }
         formVisibility(formVisible)
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
         formVisible = true
      }
   }
   
   private func handleAuthAutomatically() {
      guard #available(iOS 11.0, *), AppAuthManager.shared.automaticallyBiometryAuth else {
         formVisible = true
         return
      }
      
      authenticate()
      formVisible = false
   }
   
   @available(iOS 11.0, *)
   private func authenticate() {
      AppAuthManager.shared.getSavedAccountsWithBiometric(reason: "An reason that I don't know") {[weak self] (accounts, error) in
         guard let self = self else { return }
         self.formVisible = accounts.isEmpty || error != nil
         
         if error != nil {
            //handler with error
         }
         
         print(accounts)
         if let firstAccount = accounts.last {
            self.loginWith(email: firstAccount.account, password: firstAccount.password)
         }
      }
   }
}

extension LoginViewModel: LoginViewModelProtocol {
   
   var biometryEnable: Bool {
      return AppAuthManager.shared.biometryIsEnable
   }
   
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
   
   func viewDidLoad() {
      handleAuthAutomatically()
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
