//
//  ErrorHandlerImplementation.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 25.04.17.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation

class ErrorHandlerImplementation: ErrorHandler {
    
    func handle(errors: [Error]) -> Error {
        if errors.count != 0 {
            return errors.last!
        }
        return NSError(domain: "DIO.assignment1", code: 1, userInfo: nil);
    }
}
