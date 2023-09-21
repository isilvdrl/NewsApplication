//
//  LoginViewController.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 10.09.2023.
//

import UIKit
import Loaf


class LoginViewController: UIViewController{
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    private let isSuccessfulLogin = true
    weak var delegate: OnboardingDelegate?
    
    private let authManager = AuthManager()
    private var loginViewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsFor(pageType: .login)
        loginViewModel = LoginViewModel(authManager: authManager)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    private enum PageType {
        case login
        case signUp
    }
    
    private var currentPageType: PageType = .login{
        didSet{
            setupViewsFor(pageType : currentPageType)
        }
        
    }
    private func setupViewsFor(pageType: PageType){
        errorLabel.text = nil
        passwordConfirmationTextField.isHidden = pageType == .login
        signUpButton.isHidden = pageType == .login
        forgetPasswordButton.isHidden = pageType == .signUp
        loginButton.isHidden = pageType == .signUp
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Forget Password", message: "Please enter your email address", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let this = self else { return }
            if let textField = alertController.textFields?.first, let email = textField.text, !email.isEmpty {
                this.loginViewModel.resetPassword(withEmail: email) { result in
                    switch result {
                    case .success:
                        this.showAlert(title: "Password Reset Successful", message: "Please check your email to find the password reset link.")
                        print("Check your mail for password link")
                    case .failure(let error):
                        Loaf(error.localizedDescription, state: .error, location: .top, sender: this).show()
                    }
                }
            }
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        

    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl){
        currentPageType = sender.selectedSegmentIndex == 0 ? .login : .signUp
    }
    
    private func showAlert(title: String,message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,handler: nil)
        alertController.addAction(okAction)
        present(alertController,animated: true,completion: nil)
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
                    !email.isEmpty,
                    let password = passwordTextField.text,
                    !password.isEmpty,
                    let passwordConfirmation = passwordConfirmationTextField.text,
                    !passwordConfirmation.isEmpty
              else {
                  showErrorMessageIfNeeded(text: "Geçersiz Form")
                  return
              }

              guard password == passwordConfirmation else {
                  showErrorMessageIfNeeded(text: "Şifreler uyuşmuyor")
                  return
              }

              loginViewModel.signUpNewUser(withEmail: email, password: password) { [weak self] result in
                  guard let this = self else { return }
                  switch result {
                  case .success:
                      this.delegate?.showMainTabBarController()
                  case .failure(let error):
                      this.showErrorMessageIfNeeded(text: error.localizedDescription)
                  }
              }

    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        view.endEditing(true)
        
        guard let email = emailTextField.text,
              !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty
        else {
            showErrorMessageIfNeeded(text: "Geçersiz form")
            return
        }

        loginViewModel.loginUser(withEmail: email, password: password) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                this.delegate?.showMainTabBarController()
            case .failure(let error):
                this.showErrorMessageIfNeeded(text: error.localizedDescription)
            }
        }
        /*view.endEditing(true)
        
        guard let email = emailTextField.text,
              !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else {
            showErrorMessageIfNeeded(text: "Invalid form")
            return
            }

        authManager.loginUser(withEmail: email, password: password) { [weak self] (result) in
            guard let this = self else{return}
            switch result {
            case .success:
                this.delegate?.showMainTabBarController()
            case .failure(let error):
                this.showErrorMessageIfNeeded(text: error.localizedDescription)
            }
            
        }
         */
    }
    
    private var errorMessage: String?{
        didSet{
            showErrorMessageIfNeeded(text: errorMessage)
        }
    }
    
    private func showErrorMessageIfNeeded(text: String?){
        errorLabel.isHidden = text == nil
        errorLabel.text = text
    }
    
}
