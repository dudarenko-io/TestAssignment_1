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
    
    var title: String {
        set {
            titleLabel.text = String(htmlEncodedString: newValue) ?? ""
        }
        get {
            return titleLabel.text ?? ""
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
