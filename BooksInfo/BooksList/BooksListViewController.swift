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
    
    private var booksList: [BookInfo] = []
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.fetchBooksListData()
        self.fetchCoversImageData()
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
    
    private func fetchCoversImageData() {
        let imgUrl = BooksApiURLs.coversApiUrlOlid.rawValue.createImageApiURL(coverEditionKey: "OL28172760M", sizeOfImage: .medium)
        print(imgUrl)
        
    }


}

