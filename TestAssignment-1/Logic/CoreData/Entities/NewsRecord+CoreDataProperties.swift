//
//  NewsRecord+CoreDataProperties.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 01/04/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import CoreData


extension NewsRecord {
    
    public class var entityName: String {
        return "NewsRecord"
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsRecord> {
        return NSFetchRequest<NewsRecord>(entityName: entityName);
    }

    @NSManaged public var content: String?
    @NSManaged public var title: NewsTitle?

}
