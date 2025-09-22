//
//  SearchViewController.swift
//  ToDayNews
//
//  Created by Nabiyev Anar on 13.08.25.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var searchResults: [NewsModel] = [] {
        didSet { tableView.reloadData() }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Start typing to find news"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        
        setupSearchController()
        updateEmptyState(isEmpty: true)
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        emptyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search news..."
        searchController.searchResultsUpdater = self
    }
    
    private func updateEmptyState(isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    func fetchSearchResult(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults.removeAll()
            updateEmptyState(isEmpty: true)
            return
        }
        
        NewsNetworkManager.shared.fetchNews(query: query) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.searchResults = response.articles
                self.updateEmptyState(isEmpty: self.searchResults.isEmpty)
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = searchResults[indexPath.row]
        let newsData = NewsTableViewCell.News(
            image: item.urlToImage ?? "",
            title: item.title ?? "",
            author: item.author ?? "",
            data: item.publishedAt ?? ""
        )
        
        let isFav = FavoritesManager.shared.isFavorite(item)
        cell.configure(news: newsData, isFavorite: isFav)
        
        cell.bookmarkTapped = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }
            
            FavoritesManager.shared.toggleFavorite(item)
            let newState = FavoritesManager.shared.isFavorite(item)
            cell.updateBookmarkIcon(isFavorite: newState)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = searchResults[indexPath.row]
        let detailVC = NewsDetailViewController(news: news)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        pendingRequestWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.fetchSearchResult(query: text)
        }
        pendingRequestWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}
