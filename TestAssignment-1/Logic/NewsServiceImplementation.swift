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
    
    // MARK: - Init
    
    init() {}
    
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
            if error != nil {
                let err = self?.errorHandler.handle(errors: [error!])
                completion(err)
                return
            }
            
            // парсинг
            if  let jsonData = data as? [String:Any],
                let newsList = self?.newsListParser.parse(json: jsonData) as? [NewsTitle] {
                
                // удаление лишних записей
                // FIXME: тут может быть косяк с потоками
                for title in newsList {
                    if (self?.storedNewsIdentifiers.contains(title.identifier))! {
                        self?.backgroundContext.perform {
                            self?.backgroundContext.delete(title)
                        }
                    }
                }
                
                // сохранение в базе
                self?.coreDataStack.backgroundContext.perform {
                    do {
                        try self?.coreDataStack.backgroundContext.save()
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    } catch let error {
                        print(error)
                        print("failed to save data in context")
                        assert(false)
                        DispatchQueue.main.async {
                            completion(error)
                        }
                    }
                }
                return
            } else {
                let parsingError = NSError(domain: "DIO.testAssignment1", code: 1, userInfo: nil);
                completion(parsingError)
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
        transport.execute(request: .getNewsDetail(identifier)) { [weak self] (error, data) in
            if error != nil {
                let err = self?.errorHandler.handle(errors: [error!])
                completion(err)
                return
            }
            
            let fetchRequest:NSFetchRequest<NewsTitle> = NewsTitle.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %d", identifier)
            
            guard let newsTitle = try? self?.coreDataStack.backgroundContext.fetch(fetchRequest).first else {
                let err = NSError(domain: "DIO.testAssignment1", code: 1, userInfo: nil);
                completion(err)
                return
            }

            if let jsonData = data as? [String:Any],
                let newsDetail = self?.newsDetailsParser.parse(json: jsonData) as? NewsRecord {
                newsTitle?.newsDetail = newsDetail
                self?.backgroundContext.perform {
                    do {
                        try self?.backgroundContext.save()
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    } catch {
                        print("details fetching error")
                        DispatchQueue.main.async {
                            let err = NSError(domain: "DIO.testAssignment1", code: 1, userInfo: nil);
                            completion(err)
                        }
                    }
                }
            } else {
                let parsingError = NSError(domain: "DIO.testAssignment1", code: 1, userInfo: nil);
                completion(parsingError)
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

}
