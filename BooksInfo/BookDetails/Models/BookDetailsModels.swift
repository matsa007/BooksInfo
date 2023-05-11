//
//  BookDetailsModels.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 11.05.23.
//

import Foundation

struct BookDetailsModelTypeA: Codable {
    let title: String
    let description: String?
}

struct BookDeatailsModelNewTypeB: Codable {
    struct Description: Codable {
        let value: String
    }
    
    let title: String
    let description: Description
}
