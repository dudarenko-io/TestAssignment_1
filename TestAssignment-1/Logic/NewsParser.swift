//
//  NewsParser.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 01/04/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import CoreData

/**
 * Парсер json
 */
class NewsParser {
    
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    
    init(with context:NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public
    
    // десериализация JSON списка новостей
    func deserializeNewsList(_ json:[String:Any]) -> [NewsTitle]? {
        if let payload = json["payload"] as? [[String:Any]] {
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
    
    // десериализация детальной информации новости
    func deserializeNewsDetail(_ json:[String:Any]) -> NewsRecord? {
        if let payload = json["payload"] as? [String:Any] {
            let newsDetail = createNewsDetail()
            newsDetail.content = payload["content"] as? String
            return newsDetail
        }
        return nil;
    }
    
    // MARK: - Private
    
    private func createNewsTitle() -> NewsTitle {
        let entity = NSEntityDescription.entity(forEntityName: NewsTitle.entityName, in: context)!
        let newsTitle = NewsTitle(entity: entity, insertInto: context)
        return newsTitle
    }
    
    private func createNewsDetail() -> NewsRecord {
        let entity = NSEntityDescription.entity(forEntityName: NewsRecord.entityName, in: context)!
        let newsDetail = NewsRecord(entity: entity, insertInto: context)
        return newsDetail
    }
}
