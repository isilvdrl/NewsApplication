//
//  APIService.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 4.09.2023.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService() 

    private let baseURL = "https://newsapi.org/v2/"
    private let apiKey = "b14d633892254ce18df04a24fb808e8d"

    func fetchNews(language: String, completion: @escaping (Result<NewsResponse, Error>) -> Void) {
        let endpoint = "top-headlines"
        let urlString = "\(baseURL)\(endpoint)?language=\(language)&apiKey=\(apiKey)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                        completion(.success(newsResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }

    
    

    func fetchNewsByCategory(category: String, language: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        let endpoint = "top-headlines"
        let apiUrl = "\(baseURL)\(endpoint)?category=\(category)&language=\(language)&apiKey=\(apiKey)"
        
        guard let url = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Empty response data", code: 1, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                completion(.success(newsResponse.articles))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    
    
    
    
}
