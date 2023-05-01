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
    func createImageApiURL(coverEditionKey: String, sizeOfImage: SizeOfImages) -> String {
        String(self + coverEditionKey + sizeOfImage.rawValue)
    }
}
