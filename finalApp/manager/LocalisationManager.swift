//
//  LocalisationManager.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 12.09.2023.
//

import Foundation
var bundleKey: UInt8 = 0

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

  

class LocalisationManager  {

    class func localisedString(_ value : String) -> String {
        return NSLocalizedString(value, comment: "")
    }
    class var selectedLanguage : String {
        let languageData = languages.filter{$0.1 == LocalData.getLanguage(LocalData.language)}
        return languageData.count > 0 ? LocalData.getLanguage(LocalData.language) : "tr"
    }
   
}

class BundleManager : Bundle {
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
            let bundle = Bundle(path: path) else {
                
                return super.localizedString(forKey: key, value: value, table: tableName)
        }
        
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    class func setLanguage(_ language: String) {
        LocalData.saveLanguage(language, LocalData.language)
        defer {
            object_setClass(Bundle.main, BundleManager.self)
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
