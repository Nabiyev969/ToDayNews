//
//  BaseTabBar.swift
//  ToDayNews
//
//  Created by Nabiyev Anar on 13.08.25.
//

import UIKit

class BaseTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = ViewController()
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        homeNavVC.tabBarItem.title = "Home"
        homeNavVC.tabBarItem.image = UIImage(systemName: "house.fill")
        
        let searchVC = SearchViewController()
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        searchNavVC.tabBarItem.title = "Search"
        searchNavVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let favoriteVC = FavoriteViewController()
        let favoriteNavVC = UINavigationController(rootViewController: favoriteVC)
        favoriteNavVC.tabBarItem.title = "Bookmarks"
        favoriteNavVC.tabBarItem.image = UIImage(systemName: "bookmark.fill")
        
        setViewControllers([homeNavVC, searchNavVC, favoriteNavVC], animated: false)
    }
}
