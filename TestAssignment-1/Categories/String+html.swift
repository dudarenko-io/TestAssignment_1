//
//  String+html.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 26/03/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import UIKit

extension String {
    init?(htmlEncodedString: String) {
        guard let encodedData = htmlEncodedString.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let attributes: [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]
        do{
            let string = try NSAttributedString(data: encodedData, options: attributes, documentAttributes: nil).string
            self.init(string)
        } catch {
            return nil
        }
    }
}
