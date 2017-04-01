//
//  NewsDetailViewController.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 26/03/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    let service = PayloadService()
    var contentID: String?
    
    @IBOutlet weak private var contentTextView: UITextView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        guard let identifier = contentID else {
            // error
            return
        }
        
        service.fetchDetailsForPayload(with: identifier) { (error, content) in
            if error != nil {
                // show downloading error
                print("downloading error")
                return
            }
            
            if let string = self.attributedText(for: content) {
                self.contentTextView.attributedText = string
            } else {
                // show processing error
                print("processing error")
            }
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
}
