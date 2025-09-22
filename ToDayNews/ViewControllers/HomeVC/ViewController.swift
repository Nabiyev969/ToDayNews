//
//  ViewController.swift
//  ToDayNews
//
//  Created by Nabiyev Anar on 13.08.25.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private var newsList: [NewsModel] = []

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "ToDay News"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NewsNetworkManager.shared.fetchNews(query: "apple") { newsModel in
            self.newsList = newsModel.articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell {
            let item = newsList[indexPath.row]
            cell.configure(news: .init(image: item.urlToImage ?? "", title: item.title ?? "", author: item.author ?? "", data: item.publishedAt ?? ""), isFavorite: FavoritesManager.shared.isFavorite(item))
            cell.bookmarkTapped = {
                FavoritesManager.shared.toggleFavorite(item)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        let detailVC = NewsDetailViewController(news: news)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
