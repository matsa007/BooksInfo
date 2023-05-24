//
//  BooksListTableViewCell.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 2.05.23.
//

import UIKit

final class BooksListTableViewCell: UITableViewCell {
    
    // MARK: - GUI
    
    private lazy var commonBookInfoStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var booksCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var bookInfoStackView : UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private lazy var booksTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    private lazy var booksPublishingYearLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubviews()
        self.setConstrains()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.booksTitleLabel.text = nil
        self.booksPublishingYearLabel.text = nil
        self.booksCoverImageView.image = nil
    }
    
    // MARK: - Constraints
    
    private func addSubviews() {
        self.contentView.addSubview(self.commonBookInfoStackView)
        self.commonBookInfoStackView.addSubview(self.booksCoverImageView)
        self.commonBookInfoStackView.addSubview(self.bookInfoStackView)
        self.bookInfoStackView.addSubview(self.booksTitleLabel)
        self.bookInfoStackView.addSubview(self.booksPublishingYearLabel)
    }
    
    private func setConstrains() {
        self.commonBookInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.booksCoverImageView.snp.makeConstraints {
            $0.right.equalTo(self.bookInfoStackView.snp.left)
            $0.top.bottom.left.equalToSuperview()
        }
        
        self.bookInfoStackView.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
        }
        
        self.booksTitleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        self.booksPublishingYearLabel.snp.makeConstraints {
            $0.top.equalTo(self.booksTitleLabel.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        }
    }
    
    // MARK: - UI Updating
    
    func setCellView(displayData: BooksListViewController.DisplayData) {
        if let bookImage = displayData.imageCoverData {
            self.booksCoverImageView.image = UIImage(data: bookImage)
        } else {
            self.booksCoverImageView.image = UIImage(systemName: "book.fill")
        }
        self.booksTitleLabel.text = displayData.title
        self.booksPublishingYearLabel.text = "First year of publishing: \n\(String(displayData.firstPublishYear ?? 0))"
    }
}
