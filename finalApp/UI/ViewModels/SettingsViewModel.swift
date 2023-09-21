//
//  SettingsViewModel.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 17.09.2023.
//

import Foundation
import Combine


class SettingsViewModel {
    private let authManager = AuthManager()

    func logoutUser() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            let result = self.authManager.logoutUser()
            switch result {
            case .success:
                promise(.success(()))
            case .failure(let error):
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func setLanguage(_ code: String) {
        let selectedLangCode = LocalData.getLanguage(LocalData.language)
        print(selectedLangCode)
        if selectedLangCode != code {
            Bundle.setLanguage(code)
            
        }
    }
    
}
