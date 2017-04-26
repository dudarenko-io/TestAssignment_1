//
//  NewsCellViewModel.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 01/04/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation

struct NewsCellViewModel {
    let identifier: Int
    let text: String
    
    init(with model:NewsTitle) {
        identifier = Int(model.identifier)
        text = model.text ?? "Title"
        assert(model.text != nil)
    }
}
