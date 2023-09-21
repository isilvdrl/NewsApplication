//
//  AnasayfaViewModel.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 17.09.2023.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    
    private let networkService = NetworkService()
    let databaseManager = DatabaseManager.shared

    func fetchNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        let selectedLanguage = LocalData.getLanguage(LocalData.language) // Seçilen dil

        networkService.fetchNews(language: selectedLanguage) { result in
            switch result {
            case .success(let newsResponse):
                let newsItems = newsResponse.articles
                completion(.success(newsItems))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchNewsByCategory(category: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        let selectedLanguage = LocalData.getLanguage(LocalData.language) // Seçilen dil

        networkService.fetchNewsByCategory(category: category, language: selectedLanguage) { result in
            switch result {
            case .success(let newsItems):
                completion(.success(newsItems))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveNewsToDatabase(title: String, description: String, content: String, publishedAt: String, sourceName: String, author: String, urlToImage: String, url: String) -> Observable<Void> {
        return databaseManager.insertNewsItem(title: title, description: description, content: content, publishedAt: publishedAt, sourceName: sourceName, author: author, urlToImage: urlToImage, url: url)
    }
    
    func isNewsItemSaved(title: String) -> Bool {
        return databaseManager.isNewsItemSaved(title: title)
    }
    
    func deleteNewsItem(title: String) -> Completable {
        return Completable.create { [weak self] completable in
            self?.databaseManager.deleteNewsItem(title: title)
            completable(.completed)
            return Disposables.create()
        }
    }
}
