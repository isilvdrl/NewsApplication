//
//  SettingsViewController.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 9.09.2023.
//

import UIKit
import FirebaseAuth
import Loaf
import Combine

class SettingsViewController: UIViewController {

    @IBOutlet weak var emailLabel:UILabel!
    private let authManager = AuthManager()
   
   // private let networkService = NetworkService()
    private let viewModel = SettingsViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    
    @IBOutlet weak var languageField: UITextField!
    var picker = UIPickerView()
    var languages = [
        (NSLocalizedString("Turkish", comment: ""), "tr"),
        (NSLocalizedString("English", comment: ""), "en"),
        (NSLocalizedString("Arabic", comment: ""), "ar"),
        
        (NSLocalizedString("German", comment: ""), "de"),
        (NSLocalizedString("Spanish", comment: ""), "es"),
        (NSLocalizedString("French", comment: ""), "fr"),
        
        (NSLocalizedString("Hebrew", comment: ""), "he"),
        (NSLocalizedString("Italian", comment: ""), "it"),
        (NSLocalizedString("Dutch", comment: ""), "nl"),
        
        (NSLocalizedString("Norwegian", comment: ""), "no"),
        (NSLocalizedString("Portuguese", comment: ""), "pt"),
        (NSLocalizedString("Russian", comment: ""), "ru"),
        
        (NSLocalizedString("Swedish", comment: ""), "sv"),
        (NSLocalizedString("Chinese", comment: ""), "zh")
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarFont(for: navigationController)
        setupViews()
        self.setupPicker()
        // Bu işlemi viewDidLoad içinde yapabilirsiniz.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        
    }
    
    private func setupViews(){
        if let email = Auth.auth().currentUser?.email{
            emailLabel.text = "Email : " + email
        }else {
            emailLabel.text = "Something wrong about email!"
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem){
       
        viewModel.logoutUser()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    Loaf(error.localizedDescription, state: .error, location: .top, sender: self).show()
                }
            }, receiveValue: { _ in
                PresenterManager.shared.show(vc: .onboarding)
            })
            .store(in: &cancellables)
       
    }
    
    //DarkMode Switch

    @IBAction func onClickedSwitch(_ sender: UISwitch) {
        if #available(iOS 13.0, *){
            
            let appDelegate = UIApplication.shared.windows.first
            if sender.isOn{
                appDelegate?.overrideUserInterfaceStyle = .dark
                return
            }
            appDelegate?.overrideUserInterfaceStyle = .light
            return
            
        }else {
            
        }
    }
    
    //Language Switch
    
    func setupPicker(){
        self.picker.backgroundColor = .gray
        self.picker = UIPickerView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 150))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.setPicerData()
        self.languageField.inputView = self.picker
    }
    func setPicerData() {
            let languageCode = LocalData.getLanguage(LocalData.language)
            if let lang = languages.filter({$0.1 == languageCode}).first {
                self.languageField.text = lang.0
                if let row = languages.firstIndex(where: { $0.1 == languageCode }) {
                    self.picker.selectRow(row, inComponent: 0, animated: false)
                }
               // self.picker.selectRow(lang.1 == "tr" ? 0 : 1, inComponent: 0, animated: false)
            }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Ekrana tıklanınca picker'ı kapat
            self.languageField.resignFirstResponder()
        }
    }

}

extension SettingsViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.languages[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.languageField.resignFirstResponder()
        let language = self.languages[row]
        self.languageField.text = language.0
        changeLanguage(language.1) // Dil değiştirme işlemini çağırın
    }
    
    func changeLanguage(_ code: String) {
            viewModel.setLanguage(code)
            updateRootViewController()
    }

    private func updateRootViewController() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if #available(iOS 13.0, *) {
                if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                }
            } else {
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                }
            }
        }
    
}
