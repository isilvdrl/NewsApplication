//
//  LoadingViewModel.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 18.09.2023.
//


import Foundation

class LoadingViewModel {
    private let authManager = AuthManager()

    func isUserLoggedIn() -> Bool {
        return authManager.isUserLoggedIn()
    }
}
