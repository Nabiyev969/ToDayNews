//
//  FavoritesManager.swift
//  ToDayNews
//
//  Created by Nabiyev Anar on 17.08.25.
//

import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "favorites_news"
    
    private var favorites: [NewsModel] = []
    
    init() {
        loadFavorites()
    }
    
    func getFavorites() -> [NewsModel] {
        return favorites
    }
    
    func isFavorite(_ news: NewsModel) -> Bool {
        return favorites.contains { $0.url == news.url }
    }
    
    func toggleFavorite(_ news: NewsModel) {
        if let index = favorites.firstIndex(where: { $0.url == news.url }) {
            favorites.remove(at: index)
        } else {
            favorites.append(news)
        }
        saveFavorites()
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([NewsModel].self, from: data) {
            favorites = decoded
        }
    }
}
