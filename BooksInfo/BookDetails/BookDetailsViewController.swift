//
//  BookDetailsViewController.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 11.05.23.
//

import UIKit
import SnapKit

final class BookDetailsViewController: UIViewController {
    
    // MARK: - Parameters
    
    private var displayModel = DisplayModel(title: "", description: "", imageUrl: "", firstYear: 0, rating: 0)
    
    private let bookKey: String
    private let imageUrl: String
    private let firstYear: Int
    private let rating: Double
    
    init(bookKey: String, imageUrl: String, firstYear: Int, rating: Double) {
        self.bookKey = bookKey
        self.imageUrl = imageUrl
        self.firstYear = firstYear
        self.rating = rating
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

extension BookDetailsViewController {
    struct DisplayModel {
        var title: String?
        var description: String?
        var imageUrl: String
        var firstYear: Int
        var rating: Double
        var image: Data?
    }
}
