//
//  NewsResponse.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 4.09.2023.
//

import Foundation
class NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
    
    init(status: String, totalResults: Int, articles: [Article]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

