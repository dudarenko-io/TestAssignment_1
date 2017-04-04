//
//  NewsWebService.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 01/04/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import Alamofire

/**
 * Сервис, загружающий данные
 * Cписок новостей и детальная информация новости
 */
class NewsWebService {
    fileprivate struct URLs {
        static let newsList = "https://api.tinkoff.ru/v1/news"
        static let newsDetail = "https://api.tinkoff.ru/v1/news_content"
    }
    
    // загрузка списка новостей
    func fetchNews(with completion:@escaping (Error?, [String:Any])->()) {
        Alamofire.request(URLs.newsList)
            .responseJSON { response in
                if let error = response.error {
                    completion(error, [String:Any]())
                    return
                }
                
                if let JSON = response.result.value as? [String:Any]{
                    completion(nil, JSON)
                } else {
                    let error = NSError(domain: "DIO.assignment1", code: 1, userInfo: nil);
                    completion(error, [String:Any]())
                }
        }
    }
    
    // загрузка деталей новости
    func fetchNewsDetail(with identifier: Int,
                                andCompletion completion:@escaping (Error?, [String:Any])->())
    {
        let parameters: Parameters = ["id": identifier]
        Alamofire.request(URLs.newsDetail,
                          method: .get,
                          parameters: parameters)
            .responseJSON { (response) in
                if let error = response.error {
                    completion(error, [String:Any]())
                    return
                }
                
                if let JSON = response.result.value as? [String:Any]{
                    completion(nil, JSON)
                } else {
                    let error = NSError(domain: "DIO.assignment1", code: 1, userInfo: nil);
                    completion(error, [String:Any]())
                }
        }
    }
    
}
