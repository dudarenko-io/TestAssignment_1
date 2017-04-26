//
//  NewsDetailParser.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 25.04.17.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import CoreData

class NewsDetailParser: Parser {
    
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    
    required init(with context:NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Parser
    
    func parse(json data:[String:Any]) -> Any? {
        if let payload = data["payload"] as? [String:Any] {
            let newsDetail = createNewsDetail()
            newsDetail.content = payload["content"] as? String
            return newsDetail
        }
        return nil;
    }
    
    // MARK: - Private
    
    private func createNewsDetail() -> NewsRecord {
        let entity = NSEntityDescription.entity(forEntityName: NewsRecord.entityName, in: context)!
        let newsDetail = NewsRecord(entity: entity, insertInto: context)
        return newsDetail
    }
}
