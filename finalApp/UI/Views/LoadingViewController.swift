//
//  LoadingViewController.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 9.09.2023.
//

import UIKit

class LoadingViewController: UIViewController {
   // private let authManager = AuthManager()
    private let loadingViewModel = LoadingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(durationInSeconds:2.0){
            self.showInitialView()
        }
    }
    

    private func showInitialView(){
        //if user logged in -> main menu
        // else onboarding
        if loadingViewModel.isUserLoggedIn() {

            PresenterManager.shared.show(vc: .mainTabBarController)
            
        }else{
            performSegue(withIdentifier: K.Segue.showOnboarding, sender: nil)
        }
    }
    
}
