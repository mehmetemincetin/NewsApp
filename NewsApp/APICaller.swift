//
//  APICaller.swift
//  NewsApp
//
//  Created by MEHMET EMİN ÇETİN on 14.09.2024.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() { }
    
    struct Constants {
        static let topHeadlinesUrl = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=e0dabb55413d4654a49514e55b80667b")
        static let searchUrlString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=e0dabb55413d4654a49514e55b80667b&q="
        
    }
    
    public func getTopStroies(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesUrl else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
// Models

struct APIResponse: Codable {
    let articles: [Article]
}
struct Article: Codable {
    let source : Source
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}
struct Source: Codable  {
    let name: String
}

