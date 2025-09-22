//
//  NewsNetworkManager.swift
//  ToDayNews
//
//  Created by Nabiyev Anar on 14.08.25.
//

import Foundation

final class NewsNetworkManager {
    
    static let shared = NewsNetworkManager()
    
    func fetchNews(query: String, complition: @escaping(ResponseModel) -> ()) {
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let urlString = "https://newsapi.org/v2/everything?q=\(encodedQuery)&sortBy=popularity&apiKey=48dcf1a7dbf0400a9ac560d971218d58"
        
        guard let url = URL(string: urlString) else { return }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                let model = try JSONDecoder().decode(ResponseModel.self, from: data)
                DispatchQueue.main.async {
                    complition(model)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
