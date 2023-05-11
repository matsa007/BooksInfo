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
    
    private var displayModel = DisplayModel(title: "", description: "", imageUrl: "", firstYear: 0, rating: 0) {
        didSet {
            self.updateUI()
        }
    }
    
    private let bookKey: String
    private let imageUrl: String
    private let firstYear: Int
    private let rating: Double
    
    // MARK: - GUI
    
    private lazy var bookCoverImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var bookTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var bookDescriptionTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var bookFirstYearTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var bookRatingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Initialization
    
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
        self.fetchBookDetailsDataTypeA()
        
        self.view.addSubview(self.bookCoverImage)
        self.bookCoverImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Fetch Data
    
    private func fetchBookDetailsDataTypeA() {
        NetworkManager.shared.makeRequest(to: BooksApiURLs.bookDetailsUrl.rawValue.createBookDetailsUrl(bookKey: self.bookKey)) { [weak self] (result: Result<BookDetailsModelTypeA, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.displayModel.title = data.title
                    self.displayModel.description = data.description
                    self.displayModel.imageUrl = self.imageUrl
                    self.displayModel.firstYear = self.firstYear
                    self.displayModel.rating = self.rating
                    self.fetchCoversImageData(bookImageUrl: self.imageUrl)
                }
            case .failure:
                self.fetchBookDetailsDataTypeB()
            }
        }
    }
    
    private func fetchBookDetailsDataTypeB() {
        NetworkManager.shared.makeRequest(to: BooksApiURLs.bookDetailsUrl.rawValue.createBookDetailsUrl(bookKey: self.bookKey)) { [weak self] (result: Result<BookDeatailsModelNewTypeB, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.displayModel.title = data.title
                    self.displayModel.description = data.description.value
                    self.displayModel.imageUrl = self.imageUrl
                    self.displayModel.firstYear = self.firstYear
                    self.displayModel.rating = self.rating
                    self.fetchCoversImageData(bookImageUrl: self.imageUrl)
                }
            case .failure(let error):
                self.alertForError(error)
            }
        }
    }
    
    private func fetchCoversImageData(bookImageUrl: String) {
        let imgUrl = BooksApiURLs.coversApiUrlOlid.rawValue.createImageApiURL(coverEditionKey: bookImageUrl, sizeOfImage: .large)
        NetworkManager.shared.getImageData(from: imgUrl) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.displayModel.image = data
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.displayModel.image = nil
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        if let imageData = self.displayModel.image {
            self.bookCoverImage.image = UIImage(data: imageData)
        } else {
            self.bookCoverImage.image = UIImage(systemName: "book.fill")
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
