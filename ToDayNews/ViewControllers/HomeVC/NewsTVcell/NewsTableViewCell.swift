//
//  NewsTableViewCell.swift
//  ToDayNews
//
//  Created by Nabiyev Anar on 13.08.25.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {
    
    var bookmarkTapped: (() -> ())?
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        return stack
    }()
    
    private let mainImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.numberOfLines = 0
        return title
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemBlue
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupUI()
        constraintsUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(mainStack)
        [mainImage, titleLabel, hStack].forEach(mainStack.addArrangedSubview)
        [authorLabel, dataLabel, bookmarkButton].forEach(hStack.addArrangedSubview)
    }
    
    private func constraintsUI() {
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        mainImage.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height / 3.5)
            make.width.equalTo(UIScreen.main.bounds.width - 16)
        }
    }
    
    @objc private func didTapBookmarkButton() {
        bookmarkTapped?()
    }
    
    func configure(news: News, isFavorite: Bool) {
        mainImage.downloadImage(from: news.image)
        titleLabel.text = news.title
        authorLabel.text = news.author
        dataLabel.text = news.data
        updateBookmarkIcon(isFavorite: isFavorite)
    }
    
    func updateBookmarkIcon(isFavorite: Bool) {
        let icon = isFavorite ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: icon), for: .normal)
    }
}

extension NewsTableViewCell {
    struct News {
        let image: String
        let title: String
        let author: String
        let data: String
    }
}
