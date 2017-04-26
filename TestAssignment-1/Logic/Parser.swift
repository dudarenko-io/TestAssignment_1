//
//  Parser.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 25.04.17.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation

/**
 Протокол парсера
 */
protocol Parser {
    /**
     Распарсить json словарь в модельный объект
     @param json json dictionary
     @return модельный объект
     */
    func parse(json data: [String:Any]) -> Any?
}
