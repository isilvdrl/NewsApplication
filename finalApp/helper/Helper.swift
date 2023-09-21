//
//  Helper.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 9.09.2023.
//

import Foundation
import UIKit

func delay(durationInSeconds seconds: Double, completion: @escaping () -> Void ){
    
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    
}
/*
func navigationBarFont(){
    // Set navigation bar title text attributes
     if let font = UIFont(name: "Times New Roman", size: 30) {
         let textAttributes: [NSAttributedString.Key: Any] = [
             NSAttributedString.Key.font: font,
            // NSAttributedString.Key.foregroundColor: UIColor.white
         ]
         navigationController?.navigationBar.titleTextAttributes = textAttributes
     }
    /*
    if let font = UIFont(name: "Times New Roman", size: 30) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font,
           // NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
    }
    */
}*/
func navigationBarFont(for navigationController: UINavigationController?) {
    // Set navigation bar title text attributes
    if let font = UIFont(name: "Times New Roman", size: 30) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
       
    }
}


extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
