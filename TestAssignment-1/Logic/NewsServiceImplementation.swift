//
//  PNewsService.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 19/03/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import CoreData

class NewsServiceImplementation: NewsService {
    
    // MARK: - Dependencies
    
    var transport: Transport!
    var newsListParser: Parser!
    var newsDetailsParser: Parser!
    var errorHandler: ErrorHandler!
    var coreDataStack: CoreDataStack! {
        didSet {
            viewContext = coreDataStack.viewContext
            backgroundContext = coreDataStack.backgroundContext
        }
    }
    private var viewContext: NSManagedObjectContext!
    private var backgroundContext: NSManagedObjectContext!
    private static let publicationDateKey = "publicationDate"
    
    // MARK: - NewsService
    
    func updateNewsList(with completion: @escaping ErrorClosure) {
        // запрос
        transport.execute(request: .getNewsList) { [weak self] (error, data) in
            guard let `self` = self else{
                return
            }
            
            if error != nil {
                let err = self.errorHandler.handle(errors: [error!])
                completion(NewsServiceError.loadingFailed(err))
                return
            }
            
            let storedNewsIdentifiers = self.storedNewsIdentifiers
            
            self.backgroundContext.perform {
                // парсинг
                guard let jsonData = data as? [String:Any],
                    let newsList = self.newsListParser.parse(json: jsonData) as? [NewsTitle] else {
                        DispatchQueue.main.async { completion(NewsServiceError.parsingFailed) }
                        return
                }
                
                // удаление лишних записей из контекста
                for title in newsList {
                    if storedNewsIdentifiers.contains(title.identifier) {
                        self.backgroundContext.delete(title)
                    }
                }
                
                // сохранение в базе
                var cacheError: Error?
                do {
                    try self.coreDataStack.backgroundContext.save()
                } catch {
                    cacheError = NewsServiceError.cachingFailed
                }
                DispatchQueue.main.async { completion(cacheError) }
            }
        }
    }
    
    func obtainNews()->([NewsTitle]) {
        let fetchRequest:NSFetchRequest<NewsTitle> = NewsTitle.fetchRequest()
    
        guard let result = try? self.viewContext.fetch(fetchRequest) else {
            print("news fetching error")
            return [NewsTitle]()
        }
        
        return result
    }
    
    lazy var resultsController: NSFetchedResultsController<NewsTitle> = {
        let fetchRequest:NSFetchRequest<NewsTitle> = NewsTitle.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: NewsServiceImplementation.publicationDateKey, ascending: false)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                           managedObjectContext: self.viewContext,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        return resultsController
    }()
    
    func updateNewsDetail(with identifier:Int, and completion:@escaping ErrorClosure) {
        // loading
        transport.execute(request: .getNewsDetail(identifier)) { [weak self] (error, data) in
            guard let `self` = self else{
                return
            }
            
            if error != nil {
                let err = self.errorHandler.handle(errors: [error!])
                completion(NewsServiceError.loadingFailed(err))
                return
            }
            
            guard let newsTitleObjectID = self.objectIDForNewsTitle(with: identifier) else {
                completion(NewsServiceError.cachingFailed)
                return
            }
            
            self.backgroundContext.perform {
                // parsing
                guard let jsonData = data as? [String:Any],
                    let newsDetail = self.newsDetailsParser.parse(json: jsonData) as? NewsRecord,
                    let newsTitle = self.backgroundContext.object(with: newsTitleObjectID) as? NewsTitle else {
                        DispatchQueue.main.async { completion(NewsServiceError.parsingFailed) }
                        return
                }

                newsTitle.newsDetail = newsDetail
                var cacheError: Error?
                do {
                    try self.backgroundContext.save()
                } catch {
                    cacheError = NewsServiceError.cachingFailed
                }
                DispatchQueue.main.async { completion(cacheError) }
            }
        }
    }

    func obtainNewsDetail(with identifier:Int)->(NewsRecord?) {
        let fetchRequest:NSFetchRequest<NewsTitle> = NewsTitle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %d", identifier)
        
        guard let result = try? self.viewContext.fetch(fetchRequest) else {
            print("news fetching error")
            return nil
        }
        
        assert(result.count == 1)
        return result.first?.newsDetail
    }
        
    // MARK: - Private
    
    private var storedNewsIdentifiers: Set<Int64> {
        var storedNewsIDs = Set<Int64>()
        let fetchRequest:NSFetchRequest<NewsTitle> = NewsTitle.fetchRequest()
        if let result = try? self.viewContext.fetch(fetchRequest) {
            let ids = result.map({ (title) -> Int64 in
                return title.identifier
            })
            storedNewsIDs = Set.init(ids)
        } else {
            print("news fetching error")
        }
        return storedNewsIDs
    }

    func objectIDForNewsTitle(with identifier:Int) -> NSManagedObjectID? {
        let fetchRequest:NSFetchRequest<NewsTitle> = NewsTitle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %d", identifier)
        
        guard let newsTitleObjectID = try? coreDataStack.viewContext.fetch(fetchRequest).first?.objectID else {
            return nil
        }
        
        return newsTitleObjectID
    }
}
