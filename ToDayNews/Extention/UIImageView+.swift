//
//  UIImageView+.swift
//  ToDayNews
//
//  Created by Nabiyev Anar on 14.08.25.
//

import UIKit

extension UIImageView {
    
    func downloadImage(from url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
