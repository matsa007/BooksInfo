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
    
    private var displayData: [DisplayData] = [] {
        didSet {
            print("DISPLAY DATA == \(self.displayData)")
            self.booksListTableView.reloadData()
        }
    }
    
    // MARK: - GUI
    
    private lazy var booksListTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BooksListTableViewCell.self, forCellReuseIdentifier: "BooksListTableViewCell")
        tableView.backgroundColor = .red
        return tableView
    }()
    
    // MARK: - ViewController Life Cycle
    
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
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Fetch Data
    
    private func fetchBooksListData() {
        NetworkManager.shared.makeRequest(to: BooksApiURLs.booksInfoApiURL.rawValue) { [weak self] (result: Result<BooksListModel, Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.booksList = data.docs
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
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.displayData.append(.init(bookInfoData: bookInfo, imageCoverData: imageData))
                    }
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.displayData.append(.init(bookInfoData: bookInfo, imageCoverData: nil))
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - Extensions

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

extension BooksListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NUMBER OF ROWS == \(self.displayData.count)")
        return self.displayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BooksListTableViewCell", for: indexPath)
                as? BooksListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
}
