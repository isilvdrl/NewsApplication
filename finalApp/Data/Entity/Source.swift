//
//  Source.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 4.09.2023.
//

import Foundation
class Source: Codable {
    let id: String?
    let name: String
    
    init(id: String?, name: String) {
        self.id = id
        self.name = name
    }
}
