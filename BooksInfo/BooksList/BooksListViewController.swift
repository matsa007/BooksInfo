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
                print(error.localizedDescription)
            }
        }
    }


}

