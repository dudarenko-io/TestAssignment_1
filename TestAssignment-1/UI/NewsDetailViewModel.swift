//
//  NewsDetailViewModel.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 01/04/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation

struct NewsDetailViewModel {
    let newsContent: String
    
    init(with model: NewsRecord) {
        newsContent = model.content ?? "News content"
        assert(model.content != nil)
    }
}
