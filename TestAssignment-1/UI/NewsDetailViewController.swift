//
//  NewsDetailViewController.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 26/03/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    var service: NewsService!
    var contentID: Int?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var contentTextView: UITextView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.text = ""
        contentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10)
        
        automaticallyAdjustsScrollViewInsets = false
        
        guard contentID != nil else {
            // error
            return
        }
        
        reloadData()
    }
    
    // MARK: - Reloading
    
    func reloadData() {
        guard let identifier = contentID else {
            // error
            return
        }
        
        if let newsDetail = service.obtainNewsDetail(with: identifier) {
            if let string = self.attributedText(for: newsDetail.content!) {
                self.contentTextView.attributedText = string
                activityIndicator.stopAnimating()
            } else {
                let userInfo = [NSLocalizedDescriptionKey: "Не удалось отобразить данные"]
                let error = NSError(domain: "DIO.test-assignment", code: 1, userInfo: userInfo)
                self.showAlert(with: error)
            }
        } else {
            service.updateNewsDetail(with: identifier, and: { [weak self] (error) in
                guard error == nil else {
                    self?.showAlert(with: error!)
                    return
                }
                self?.reloadData()
            })
        }

    }
    
    // MARK: - Content Processing
    
    private func attributedText(for content:String) -> NSAttributedString? {
        guard let encodedData = content.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let documentAttributes: [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSMutableAttributedString(data: encodedData,
                                                                 options: documentAttributes,
                                                                 documentAttributes: nil)
        else {
            return nil
        }
        
        let fontAttributes: [String: Any] = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 16.0)
        ]
        
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes(fontAttributes, range: range)
        
        return (attributedString.copy() as! NSAttributedString)
    }
    
    // MARK: - Alert
    
    func showAlert(with error:Error) {
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default) { _ in
            let _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
