//
//  NewsDetailViewController.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 26/03/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController {
    
    let service = PayloadService()
    var contentID: String?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        
        guard let identifier = contentID else {
            return
        }
        
        service.fetchDetailsForPayload(with: identifier) { (error, content) in
            if error != nil {
                // show error
                return
            }
            
            let webView = WKWebView(frame: self.view.bounds)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // add css?
            webView.loadHTMLString(content, baseURL: nil)
            self.view.addSubview(webView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }
}
