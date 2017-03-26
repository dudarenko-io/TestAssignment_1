//
//  PayloadService.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 19/03/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import Alamofire

class PayloadService {
    
    fileprivate struct URLs {
        static let newsList = "https://api.tinkoff.ru/v1/news"
        static let newsDetail = "https://api.tinkoff.ru/v1/news_content"
    }
    
    func fetchPayload(with completion:@escaping (Error?, [String])->()) {
        Alamofire.request(URLs.newsList)
            .responseJSON { response in
            if let error = response.error {
                completion(error, [String]())
                return
            }
            
            if let JSON = response.result.value as? [String:Any]{
                self.deserialize(JSON) {titles in
                    completion(nil, titles)
                }
            }
        }
    }
    
    fileprivate func deserialize(_ json:[String:Any], completionHandler:@escaping ([String])->()) {
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            var titles = [String]()
            
            if let payload = json["payload"] as? [[String:Any]] {
                for item in payload {
                    if let title = item["text"] as? String {
                        titles.append(title);
                    }
                }
            }
            DispatchQueue.main.async {
                completionHandler(titles)
            }
        }
    }
    
    func fetchDetailsForPayload(with identifier: String,
                                andCompletion completion:@escaping (Error?, String)->())
    {
        let parameters: Parameters = ["id": identifier]
        Alamofire.request(URLs.newsDetail,
                          method: .get,
                          parameters: parameters)
            .responseJSON { (response) in
            if let error = response.error {
                completion(error, String())
                return
            }
            
            if let JSON = response.result.value as? [String:Any]{
                if let payload = JSON["payload"] as? [String:Any] {
                    if let title = payload["content"] as? String {
                        completion(nil, title)
                    }
                }

            }
        }
    }
}
