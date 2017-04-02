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
    
    fileprivate let context: NSManagedObjectContext
    
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
                newsTitle.text = item["text"] as? String
                newsTitle.publicationDate = item["publicationDate"] as? NSDate
                newsTitle.identifier = item[""] as? Int64 ?? 0
                
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
