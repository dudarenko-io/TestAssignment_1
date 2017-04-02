//
//  NewsTableViewCell.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 26/03/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    
    fileprivate var title: String {
        set {
            titleLabel.text = String(htmlEncodedString: newValue) ?? ""
        }
        get {
            return titleLabel.text ?? ""
        }
    }
    
    func configure(with viewModel:NewsCellViewModel) {
        title = viewModel.text
    }
}
