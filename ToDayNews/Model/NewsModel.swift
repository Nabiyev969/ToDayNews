//
//  NewsModel.swift
//  ToDayNews
//
//  Created by Nabiyev Anar on 14.08.25.
//

struct ResponseModel: Codable {
    let articles: [NewsModel]
}

struct NewsModel: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
