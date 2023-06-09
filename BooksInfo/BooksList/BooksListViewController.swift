//
//  ViewController.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 2.05.23.
//

import UIKit
import SnapKit

final class BooksListViewController: UIViewController {
    
    // MARK: - Parameters
    
    typealias BookInfo = BooksListModel.BookInfo
    
    private var booksList: [BookInfo] = [] {
        didSet {
            self.fetchCoversImageData(booksList: self.booksList)
        }
    }
    
    private var displayData: [DisplayData] = [] {
        didSet {
            self.booksListTableView.reloadData()
        }
    }
    
    private let booksLoadingLimit: Int = 10
    private var offsetIndex: Int = 0
    private var booksFound: Int?
    private var isLoading = true
    
    // MARK: - GUI
    
    private lazy var booksListTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BooksListTableViewCell.self, forCellReuseIdentifier: "BooksListTableViewCell")
        tableView.backgroundColor = .lightGray
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.view.addSubview(self.booksListTableView)
        self.setConstraints()
        self.fetchBooksListData()
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        self.booksListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Fetch Data
    
    private func fetchBooksListData() {
        NetworkManager.shared.makeRequest(to: BooksApiURLs.booksInfoApiURL.rawValue.createBooksListApiURL(limit: booksLoadingLimit, offset: offsetIndex)) { [weak self] (result: Result<BooksListModel, Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.booksList = data.docs
                    self.booksFound = data.numFound
                    self.isLoading = false
                }
            case .failure(let error):
                self.alertForError(error)
            }
        }
    }
    
    private func fetchMoreBooksListData() {
        self.offsetIndex += 10
        self.isLoading = true
        let booksQuantity = (self.booksFound ?? 0) - self.booksLoadingLimit - self.offsetIndex
        if booksQuantity > 0 {
            NetworkManager.shared.makeRequest(to: BooksApiURLs.booksInfoApiURL.rawValue.createBooksListApiURL(limit: booksLoadingLimit, offset: offsetIndex)) { [weak self] (result: Result<BooksListModel, Error>) in
                guard let self else { return }
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.booksListTableView.tableFooterView = nil
                        self.booksList = data.docs
                        self.isLoading = false
                    }
                case .failure(let error):
                    self.alertForError(error)
                }
            }
        } else {
            self.alertNoDataWillMoreLoaded("There are no more books for vieing ...")
            self.booksListTableView.tableFooterView = nil
        }
    }
    
    private func fetchCoversImageData(booksList: [BookInfo]) {
        booksList.forEach { bookInfo in
            let imgUrl = BooksApiURLs.coversApiUrlOlid.rawValue.createImageApiURL(coverEditionKey: bookInfo.coverEditionKey, sizeOfImage: .medium)
            NetworkManager.shared.getImageData(from: imgUrl) { [weak self] (result: Result<Data, Error>) in
                guard let self else { return }
                switch result {
                case .success(let data):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.displayData.append(.init(data: bookInfo, imageData: data))
                    }
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.displayData.append(.init(data: bookInfo, imageData: nil))
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - Extensions

extension BooksListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.displayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BooksListTableViewCell", for: indexPath)
                as? BooksListTableViewCell else { return UITableViewCell() }
        let displayData = self.displayData[indexPath.row]
        cell.setCellView(displayData: displayData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookInfo = self.displayData[indexPath.row]
        let bookDetailsVc = BookDetailsViewController(bookKey: bookInfo.bookKey, imageUrl: bookInfo.imageUrl, firstYear: bookInfo.firstPublishYear ?? 0, rating: bookInfo.bookRating)
        self.present(bookDetailsVc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > (self.booksListTableView.contentSize.height - scrollView.frame.size.height - 100) && !isLoading {
            self.booksListTableView.tableFooterView = self.createSpinnerFooter()
            self.fetchMoreBooksListData()
        }
    }
}

extension BooksListViewController {
    struct DisplayData {
        let title: String
        let firstPublishYear: Int?
        let imageCoverData: Data?
        let bookKey: String
        let imageUrl: String
        let bookRating: Double
        
        init(data: BookInfo, imageData: Data?) {
            self.title = data.title
            self.firstPublishYear = data.firstPublishYear
            self.imageCoverData = imageData
            self.bookKey = data.key
            self.imageUrl = data.coverEditionKey
            self.bookRating = data.ratingsAverage ?? 0.0
        }
    }
}
