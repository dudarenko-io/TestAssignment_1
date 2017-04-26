//
//  NewsTitle+CoreDataProperties.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 01/04/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import CoreData


extension NewsTitle {
    
    public class var entityName: String {
        return "NewsTitle"
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsTitle> {
        return NSFetchRequest<NewsTitle>(entityName: entityName);
    }

    @NSManaged public var identifier: Int64
    @NSManaged public var text: String?
    @NSManaged public var publicationDate: NSDate?
    @NSManaged public var newsDetail: NewsRecord?

}
