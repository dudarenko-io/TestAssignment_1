//
//  PNewsService.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 19/03/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import CoreData

/**
 * Сервис, предоставляющий данные в UI 
 * Cписок новостей и детальная информация новости
 */
class NewsService {
    
    fileprivate let webService = NewsWebService()
    fileprivate let coreDataStack = CoreDataStack()
    lazy fileprivate var parser: NewsParser = {
        return NewsParser(with: self.coreDataStack.backgroundContext)
    }()
    
    var viewContext:NSManagedObjectContext {
        return coreDataStack.viewContext
    }
    
    func obtainNews(with completion:@escaping(Error?)->()){
        // запрос
        webService.fetchNews { (error, json) in
            if error != nil {
                // error
                print("error loading data")
                completion(error)
                return
            }
            
            
            var storedNewsIDs: Set<Int64>
            let fetchRequest:NSFetchRequest<NewsTitle> = NewsTitle.fetchRequest()
            do{
                let result = try self.coreDataStack.viewContext.fetch(fetchRequest)
                let ids = result.map({ (title) -> Int64 in
                    return title.identifier
                })
                storedNewsIDs = Set.init(ids)
            } catch {
                print("fetching error")
                return
            }
            
            // парсинг
            // FIXME: - перенести в поток контекста
            if let newsTitles = self.parser.deserializeNewsList(json) {
                // поиск дубликатов
                for title in newsTitles {
                    if storedNewsIDs.contains(title.identifier) {
                        self.coreDataStack.backgroundContext.perform {
                            self.coreDataStack.backgroundContext.delete(title)
                        }
                    }
                }

                
                // сохранение в базе
                self.coreDataStack.backgroundContext.perform {
                    do {
                        try self.coreDataStack.backgroundContext.save()
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    } catch let error {
                        print(error)
                        print("failed to save data in context")
                        DispatchQueue.main.async {
                            completion(error)
                        }
                        return
                    }
                }
            } else {
                print("error parsing data")
                let err = NSError(domain: "DIO.testAssignment1", code: 1, userInfo: nil)
                completion(err)
            }
        }
    }
    
    func obtainNewsDetail(with identifier:Int, and completion:@escaping(Error?, NewsDetailViewModel?)->()){
        // проверка в базе
        // если есть, то показываем
        // если нет, то 
        // загружаем
        // парсим
        // кладем в базу
        
        
//        let fetchRequest:NSFetchRequest<NewsTitle> = NewsTitle.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
//        do {
//            let result = try self.coreDataStack.viewContext.fetch(fetchRequest)
//        } catch let error {
//            print("fetching error")
//            completion(error, nil)
//        }
        
//        if let newsDetail = re
        
        
        webService.fetchNewsDetail(with: identifier) { (error, json) in
            if error != nil {
                // error
                print("error loading data")
                return
            }
            
            if let newsDetail = self.parser.deserializeNewsDetail(json) {
                let viewModel = NewsDetailViewModel(with: newsDetail)
                completion(nil, viewModel)
            } else {
                let err = NSError(domain: "DIO.testAssignment1", code: 1, userInfo: nil)
                completion(err, nil)
            }
        }
    }
}
