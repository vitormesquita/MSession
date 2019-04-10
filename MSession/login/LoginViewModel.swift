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
   
   var loggedIn: (() -> Void)? { get set }
   var shouldHideForm: ((Bool) -> Void)? { get set }
   
   func viewDidLoad()
   func signIn(email: String?, password: String?, biometry: Bool)
}

class LoginViewModel {
   
   var loggedIn: (() -> Void)?
   var shouldHideForm: ((Bool) -> Void)?
   
   private func formVisibility(isHidden: Bool) {
      guard let shouldHideFormBlock = shouldHideForm else { return }
      shouldHideFormBlock(isHidden)
   }
   
   private func handleAuthAutomatically() {
      guard #available(iOS 11.0, *), AppAuthManager.shared.automaticallyBiometryAuth else {
         formVisibility(isHidden: false)
         return
      }
      
      authenticate()
      formVisibility(isHidden: true)
   }
   
   private func authenticate() {
      guard #available(iOS 11.0, *) else { return }
      
      AppAuthManager.shared.getSavedAccountsWithBiometric(reason: "An reason that I don't know") {[weak self] (accounts, error) in
         guard let self = self else { return }
         self.formVisibility(isHidden: !accounts.isEmpty && error == nil)
         
         if error != nil {
            //handler with error
         }
         
         if let firstAccount = accounts.first {
            self.loginWith(email: firstAccount.account, password: firstAccount.password)
         }
      }
   }
   
   private func loginWith(email: String, password: String) {
      if email == "mano@jera.com.br" && password == "secret123" {
         
         AppAuthManager.shared.saveAccount(account: email, password: password) { (error) in
            print(error?.localizedDescription ?? "saved with success")
         }
         
         if let loggedInBlock = loggedIn {
            loggedInBlock()
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
