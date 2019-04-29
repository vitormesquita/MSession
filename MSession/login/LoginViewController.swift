//
//  LoginViewController.swift
//  MSession
//
//  Created by Vitor Mesquita on 08/04/19.
//

import UIKit

class LoginViewController: BaseViewController {
   
   @IBOutlet weak var containerView: UIView!
   @IBOutlet weak var fieldStackView: UIStackView!
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var loginButton: UIButton!
   @IBOutlet weak var biometryIDContainerView: UIView!
   @IBOutlet weak var biometryIDLabel: UILabel!
   @IBOutlet weak var biometryIDSwitch: UISwitch!
   
   private var shouldSignIn: Bool = false {
      didSet {
         loginButton.setTitle(shouldSignIn ? "Sign in" : "Enter", for: .normal)
      }
   }
   
   private lazy var viewModel: LoginViewModelProtocol = {
      return LoginViewModel()
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      applyLayout()
      
      bind()
      
      emailTextField.delegate = self
      emailTextField.addTarget(self, action: #selector(self.textDidChange), for: .editingChanged)
      
      passwordTextField.delegate = self
      passwordTextField.addTarget(self, action: #selector(self.textDidChange), for: .editingChanged)
      
      loginButton.addTarget(self, action: #selector(self.signInDidTap), for: .touchUpInside)
   }
   
   private func applyLayout() {
      title = "Login"
      
      emailTextField.isHidden = true
      emailTextField.returnKeyType = .next
      emailTextField.placeholder = "E-mail"
      emailTextField.keyboardType = .emailAddress
      
      passwordTextField.isHidden = true
      passwordTextField.returnKeyType = .done
      passwordTextField.placeholder = "Password"
      passwordTextField.keyboardType = .default
      passwordTextField.isSecureTextEntry = true
      
      loginButton.layer.cornerRadius = 4
      loginButton.backgroundColor = .primary
      loginButton.isEnabled = true
      loginButton.setTitle("Enter", for: .normal)
      loginButton.setTitleColor(.white, for: .normal)
      loginButton.setTitle("Fill data", for: .disabled)
      
      biometryIDContainerView.isHidden = true
   }
   
   private func fieldAnimation(isVisible: Bool) {
      UIView.animate(withDuration: 0.3) {
         self.emailTextField.isHidden = !isVisible
         self.passwordTextField.isHidden = !isVisible         
         self.biometryIDContainerView.isHidden = (!isVisible || self.viewModel.biometryText == nil)
      }
   }
   
   private func bind() {
      biometryIDLabel.text = viewModel.biometryText
      biometryIDSwitch.isOn = viewModel.automaticallySigninIsEnable
      
      viewModel.fieldsVisibility = {[unowned self] isVisible in
         self.fieldAnimation(isVisible: isVisible)
         self.shouldSignIn = isVisible
      }
   }
   
   // MARK: - Actions
   
   @objc private func textDidChange() {
      loginButton.isEnabled = formIsEnable
   }
   
   @objc private func signInDidTap() {
      view.endEditing(true)
      
      guard shouldSignIn else {
         viewModel.verifyAutoAuth()
         return
      }
      
      viewModel.signIn(email: emailTextField.text,
                       password: passwordTextField.text,
                       biometry: biometryIDSwitch.isOn)
   }
}

extension LoginViewController: UITextFieldDelegate {
   
   var formIsEnable: Bool {
      return !(emailTextField.text ?? "").isEmpty
         && !(passwordTextField.text ?? "").isEmpty
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField === emailTextField {
         _ = passwordTextField.becomeFirstResponder()
      } else if textField === passwordTextField && formIsEnable {
         signInDidTap()
      } else {
         _ = textField.resignFirstResponder()
      }
      return false
   }
}
