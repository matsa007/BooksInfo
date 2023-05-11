//
//  URL.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 2.05.23.
//

import Foundation

enum BooksApiURLs: String {
    case booksInfoApiURL = "https://openlibrary.org/search.json?author=Stephen+King&limit=10&offset=0"
    case coversApiUrlOlid = "https://covers.openlibrary.org/b/olid/"
    case bookDetailsUrl = "https://openlibrary.org"
}
