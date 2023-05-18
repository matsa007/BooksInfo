//
//  String+Ex.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 2.05.23.
//

import Foundation

enum SizeOfImages: String {
    case small = "-S.jpg"
    case medium = "-M.jpg"
    case large = "-L.jpg"
}

extension String {
    func createBooksListApiURL(limit: Int, offset: Int) -> String {
        String(self + "&limit=\(limit)" + "&offset=\(offset)")
    }
    
    func createImageApiURL(coverEditionKey: String, sizeOfImage: SizeOfImages) -> String {
        String(self + coverEditionKey + sizeOfImage.rawValue)
    }
    
    func createBookDetailsUrl(bookKey: String) -> String {
        String(self + bookKey + ".json")
    }
}
