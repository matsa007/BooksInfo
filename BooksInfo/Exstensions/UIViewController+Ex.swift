//
//  UIViewController+Ex.swift
//  BooksInfo
//
//  Created by Сергей Матвеенко on 2.05.23.
//

import UIKit

extension UIViewController {
    func alertForError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alertNoDataWillMoreLoaded(_ message: String) {
        let alert = UIAlertController(title: "SORRY", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = .white
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}

