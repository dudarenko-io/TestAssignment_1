//
//  PNewsService.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 19/03/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation

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
    
    func obtainNews(with completion:@escaping([NewsCellViewModel])->()){
        // запрос
        // парсинг
        // сохранение в базе
        
        webService.fetchNews { (error, json) in
            if error != nil {
                // error
                print("error loading data")
                return
            }
            
            if let titles = self.parser.deserializeNewsList(json) {
                let viewModels = titles.map({ (title) -> NewsCellViewModel in
                    return NewsCellViewModel(with: title)
                })
                completion(viewModels)
            } else {
                print("error parsing data")
                completion([NewsCellViewModel]())
            }
        }
    }
    
    func obtainNewsDetail(with identifier:String, and completion:@escaping(NewsDetailViewModel?)->()){
        // проверка в базе
        // если есть, то показываем
        // если нет, то 
        // загружаем
        // парсим
        // кладем в базу
        
        webService.fetchNewsDetail(with: identifier) { (error, json) in
            if error != nil {
                // error
                print("error loading data")
                return
            }
            
            if let newsDetail = self.parser.deserializeNewsDetail(json) {
                let viewModel = NewsDetailViewModel(with: newsDetail)
                completion(viewModel)
            } else {
                completion(nil)
            }
        }
    }
}
