//
//  LoginViewModel.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 18.09.2023.
//

import Foundation
import Firebase

class LoginViewModel {
    private let authManager: AuthManager

    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    func resetPassword(withEmail email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authManager.resetPassword(withEmail: email, completion: completion)
    }

    func signUpNewUser(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        authManager.signUpNewUser(withEmail: email, password: password, completion: completion)
    }
    
    func loginUser(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        authManager.loginUser(withEmail: email, password: password, completion: completion)
    }

}

