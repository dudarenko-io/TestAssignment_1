//
//  SessionManager.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 25.04.17.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityIndicator

class SessionManager: Transport {
    
    // Mark: - Transport
    
    init() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    
    // Mark: - Transport
    
    func execute(request:RequestRouter, completion:@escaping (Error?, Any?)->()) {
        Alamofire.request(request).responseJSON {  (response) in
            if let error = response.error {
                completion(error, nil)
                return
            }
            
            switch response.result {
            case .failure(let error):
                completion(error, nil)
            case .success(let json):
                completion(nil, json)
            }
        }
    }
}
