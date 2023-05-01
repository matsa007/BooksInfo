//
//  ViewController.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 2.05.23.
//

import UIKit
import SnapKit

class BooksListViewController: UIViewController {
    
    // MARK: - Parameters
    
    typealias BookInfo = BooksListModel.BookInfo
    
    private var booksList: [BookInfo] = [] {
        didSet {
            self.fetchCoversImageData(booksList: self.booksList)
        }
    }
    
    private var displayData: [DisplayData] = []
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.fetchBooksListData()
    }
    
    // MARK: - Fetch Data
    
    private func fetchBooksListData() {
        NetworkManager.shared.makeRequest(to: BooksApiURLs.booksInfoApiURL.rawValue) { [weak self] (result: Result<BooksListModel, Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.booksList = data.docs
                    print("BOOKS LIST == \(self.booksList)")
                }
            case .failure(let error):
                self.alertForError(error)
            }
        }
    }
    
    private func fetchCoversImageData(booksList: [BookInfo]) {
        booksList.forEach { bookInfo in
            let imgUrl = BooksApiURLs.coversApiUrlOlid.rawValue.createImageApiURL(coverEditionKey: bookInfo.coverEditionKey, sizeOfImage: .medium)
            NetworkManager.shared.getImageData(from: imgUrl) { [weak self] (result: Result<Data, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let imageData):
                    print("IMAGE DATA == \(imageData)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension BooksListViewController {
    struct DisplayData {
        let title: String
        let firstPublishYear: Int?
        let bookKey: String
        let bookRating: Double?
        let coverEditionKey: String
        let imageCoverData: Data?
        
        init(bookInfoData: BookInfo, imageCoverData: Data?) {
            self.title = bookInfoData.title
            self.firstPublishYear = bookInfoData.firstPublishYear
            self.bookKey = bookInfoData.key
            self.bookRating = bookInfoData.ratingsAverage
            self.coverEditionKey = bookInfoData.coverEditionKey
            self.imageCoverData = imageCoverData
        }
    }
}

