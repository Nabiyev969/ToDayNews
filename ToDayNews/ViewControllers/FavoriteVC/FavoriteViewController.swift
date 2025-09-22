//
//  FavoriteViewController.swift
//  ToDayNews
//
//  Created by Nabiyev Anar on 13.08.25.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    private var favorites: [NewsModel] = []
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favorites = FavoritesManager.shared.getFavorites()
        tableView.reloadData()
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell {
            let item = favorites[indexPath.row]
            cell.configure(news: .init(image: item.urlToImage ?? "", title: item.title ?? "", author: item.author ?? "", data: item.publishedAt ?? ""), isFavorite: FavoritesManager.shared.isFavorite(item))
            cell.bookmarkTapped = {
                FavoritesManager.shared.toggleFavorite(item)
                self.favorites = FavoritesManager.shared.getFavorites()
                tableView.reloadData()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = favorites[indexPath.row]
        let detailVC = NewsDetailViewController(news: news)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
