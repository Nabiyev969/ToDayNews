//
//  NewsDetailViewController.swift
//  ToDayNews
//
//  Created by Nabiyev Anar on 16.08.25.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    private let news: NewsModel
        
    init(news: NewsModel) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    private let contentView = UIView()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var mainImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.downloadImage(from: news.urlToImage ?? "")
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = .zero
        label.text = news.title
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = .zero
        label.text = news.description
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = .zero
        label.text = news.content
        return label
    }()
    
    private lazy var readMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read More", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapReadMoreButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(vStack)
        
        [mainImage, titleLabel, descriptionLabel, contentLabel, readMoreButton].forEach(vStack.addArrangedSubview)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        mainImage.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height / 3.5)
        }
        
        readMoreButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    @objc
    func didTapReadMoreButton() {
        guard let urlString = news.url else { return }
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
