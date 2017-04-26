//
//  Transport.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 25.04.17.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation

/**
 Протокол транспорта
 */
protocol Transport {
    /**
     
     */
    func execute(request: RequestRouter, completion: @escaping (Error?, Any?)->())
}
