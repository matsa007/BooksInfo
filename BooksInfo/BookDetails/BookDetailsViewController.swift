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
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private lazy var bookCoverImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bookDescriptionTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        return label
    }()
    
    private lazy var bookFirstYearTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        return label
    }()
    
    private lazy var bookRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        return label
    }()
    
    private lazy var bookRatingImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
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
        self.view.backgroundColor = .lightGray
        self.fetchBookDetailsDataTypeA()
        self.addSubviews()
        self.setConstraints()
    }
    
    // MARK: - Adding views and setting constraints
    
    private func addSubviews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(bookTitleLabel)
        self.scrollView.addSubview(self.bookCoverImage)
        self.scrollView.addSubview(self.bookFirstYearTitle)
        self.scrollView.addSubview(self.bookRatingLabel)
        self.scrollView.addSubview(self.bookRatingImageView)
        self.scrollView.addSubview(self.bookDescriptionTitle)
        self.scrollView.layoutIfNeeded()
    }
    
    private func setConstraints() {
        self.scrollView.contentSize = self.view.bounds.size
        self.scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.bookTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        self.bookCoverImage.snp.makeConstraints {
            $0.top.equalTo(self.bookTitleLabel.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(2)
        }
        
        self.bookFirstYearTitle.snp.makeConstraints {
            $0.top.equalTo(self.bookCoverImage.snp.bottom).offset(10)
            $0.width.equalToSuperview()
        }
        
        self.bookRatingLabel.snp.makeConstraints {
            $0.top.equalTo(self.bookFirstYearTitle.snp.bottom)
            $0.left.equalToSuperview()
            $0.width.equalTo(self.view.frame.width*3/4)
            $0.height.equalTo(100)
        }
        
        self.bookRatingImageView.snp.makeConstraints {
            $0.top.equalTo(self.bookFirstYearTitle.snp.bottom)
            $0.left.equalTo(self.bookRatingLabel.snp.right)
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalTo(self.bookRatingLabel.snp.height)
        }
        
        self.bookDescriptionTitle.snp.makeConstraints {
            $0.top.equalTo(self.bookRatingLabel.snp.bottom)
            $0.width.equalToSuperview()
        }
    }
    
    // MARK: - Fetch Data
    
    private func fetchBookDetailsDataTypeA() {
        NetworkManager.shared.makeRequest(to: BooksApiURLs.bookDetailsUrl.rawValue.createBookDetailsUrl(bookKey: self.bookKey)) { [weak self] (result: Result<BookDetailsModelTypeA, Error>) in
            guard let self else { return }
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
            guard let self else { return }
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
            guard let self else { return }
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
    
    // MARK: - UI Updating
    
    private func updateUI() {
        if let imageData = self.displayModel.image {
            self.bookCoverImage.image = UIImage(data: imageData)
        } else {
            self.bookCoverImage.image = UIImage(systemName: "book.fill")
        }
        
        if let title = self.displayModel.title {
            self.bookTitleLabel.text = "\n\(title)\n"
        } else {
            self.bookTitleLabel.text = "\nNO TITLE\n"
        }
        
        if let description = self.displayModel.description {
            self.bookDescriptionTitle.text = "Description:\n\n\n\(description)"
        } else {
            self.bookDescriptionTitle.text = "NO DESCRIPTION"
        }
        
        self.bookFirstYearTitle.text = "First published in \(self.displayModel.firstYear) year"
        self.bookRatingLabel.text = "Rating is - \(self.displayModel.rating)"
        self.ratingImageUpdating(rating: self.displayModel.rating)
    }
    
    private func ratingImageUpdating(rating: Double) {
        let ratingImageName: RatingImageName
        switch rating {
        case 1..<2:
            ratingImageName = .ratingOne
        case 2..<3:
            ratingImageName = .ratingTwo
        case 3..<4:
            ratingImageName = .ratingThree
        case 4..<4.5:
            ratingImageName = .ratingFour
        case 4.5...:
            ratingImageName = .ratingFive
        default:
            ratingImageName = .ratingZero
        }
        
        self.bookRatingImageView.image = UIImage(named: ratingImageName.rawValue)
    }
}

// MARK: - Extensions

private extension BookDetailsViewController {
    struct DisplayModel {
        var title: String?
        var description: String?
        var imageUrl: String
        var firstYear: Int
        var rating: Double
        var image: Data?
    }

    enum RatingImageName: String {
        case ratingZero
        case ratingOne
        case ratingTwo
        case ratingThree
        case ratingFour
        case ratingFive
    }
}
