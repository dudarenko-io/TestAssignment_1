//
//  File.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 25.04.17.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import CoreData

class NewsListParser: Parser {
    
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    
    required init(with context:NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Parser
    
    func parse(json data:[String:Any]) -> Any? {
        if let payload = data["payload"] as? [[String:Any]] {
            var titles = [NewsTitle]()
            for item in payload {
                let newsTitle = self.createNewsTitle()
                if let title = item["text"] as? String {
                    newsTitle.text = title
                }
                if let publicationDate = item["publicationDate"] as? [String:Any],
                    let milliseconds = publicationDate["milliseconds"] as? Int
                {
                    let date = Date.init(timeIntervalSince1970: Double(milliseconds/1000))
                    newsTitle.publicationDate = date as NSDate?
                }
                
                if let identifierString = item["id"] as? String,
                    let identifier = Int64(identifierString)
                {
                    newsTitle.identifier = identifier
                }
                
                titles.append(newsTitle)
            }
            return titles
        }
        return nil
    }
    
    // MARK: - Private
    
    private func createNewsTitle() -> NewsTitle {
        let entity = NSEntityDescription.entity(forEntityName: NewsTitle.entityName, in: context)!
        let newsTitle = NewsTitle(entity: entity, insertInto: context)
        return newsTitle
    }
}
