//
//  Slide.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 10.09.2023.
//

import Foundation

struct Slide {
    let imageName : String
    let title : String
    let description: String
    
    static let collection: [Slide] = [
        Slide(imageName: "image_app", title: NSLocalizedString("Welcome to PressPass!", comment: ""),
              description: NSLocalizedString("We're here to provide you with the latest news from around the world and tailored content to match your interests", comment: "")),
        Slide(imageName: "image_tech", title: NSLocalizedString("Great news for tech enthusiasts!", comment: ""),
              description: NSLocalizedString("We're making technology more understandable and enjoyable for you.", comment: "")),
        Slide(imageName: "image_tech2", title: NSLocalizedString("Don't miss exciting tech developments every day!", comment: ""),
              description: NSLocalizedString("We'll keep you informed about the latest software updates, hardware reviews, and digital innovations.", comment: "")),
        Slide(imageName: "image_sport", title: NSLocalizedString("PressPass for not missing news from every sport branch!", comment: ""),
              description: NSLocalizedString("Latest basketball, football, tennis, and more are here.", comment: "")),
        Slide(imageName: "image_business", title: NSLocalizedString("Keeping up with the pulse of the business world is now easier!", comment: ""),
              description: NSLocalizedString("PressPass provides up-to-date business news and analyses for all business professionals.", comment: "")),
        Slide(imageName: "image_predict", title: NSLocalizedString("Follow opportunities in the financial world and economic analyses closely!", comment: ""),
              description: NSLocalizedString("PressPass helps you understand economic news better with its user-friendly interface.", comment: ""))
    ]
}
