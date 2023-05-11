//
//  BookDetailsViewController.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 11.05.23.
//

import UIKit

final class BookDetailsViewController: UIViewController {
    
    // MARK: - ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        self.fetchBookDetailsData()
    }
    
    // MARK: - Fetch Data
    
    private func fetchBookDetailsData() {
        NetworkManager.shared.makeRequest(to: BooksApiURLs.bookDetailsUrl.rawValue.createBookDetailsUrl(bookKey: "/works/OL81626W")) { [weak self] (result: Result<BookDetailsModel, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    print(data)
            
                }
            case .failure(let error):
                print(error)
                self.alertForError(error)
            }
        }
    }

}
