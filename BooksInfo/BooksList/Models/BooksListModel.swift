//
//  BooksListModel.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 2.05.23.
//

import Foundation

struct BooksListModel: Codable {
    struct BookInfo: Codable {
        let key: String
        let title: String
        let firstPublishYear: Int?
        let ratingsAverage: Double?
        let coverEditionKey: String
        
        enum CodingKeys: String, CodingKey {
            case key
            case title
            case firstPublishYear = "first_publish_year"
            case ratingsAverage = "ratings_average"
            case coverEditionKey = "cover_edition_key"
        }
    }
    
    let numFound: Int
    let start: Int
    let docs: [BookInfo]
    let offset: Int
}
