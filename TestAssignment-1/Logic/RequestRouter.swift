//
//  RequestRouter.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 25.04.17.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import Alamofire

enum RequestRouter: URLRequestConvertible {
    case getNewsList
    case getNewsDetail(Int)
    
    private static let baseURLString = "https://api.tinkoff.ru/v1"
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters?) = {
            switch self {
            case .getNewsList:
                return ("/news", nil)
            case .getNewsDetail(let newsID):
                return ("/news_content", ["id": newsID])
            }
        }()
        
        let url = RequestRouter.baseURLString.appending(result.path)
        let request = try URLRequest(url:url, method: .get)
        return try URLEncoding.default.encode(request, with: result.parameters)
    }
}
