//
//  ErrorHandler.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 25.04.17.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation

/**
 Протокол обработки ошибок
 */
protocol ErrorHandler {
    /**
     Обрабатывает массив ошибок
     @param errors массив ошибок
     @return актуальная ошибка
     */
    func handle(errors: [Error]) -> Error
}
