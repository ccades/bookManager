//
//  BKError.swift
//  BookManager
//
//  Created by CC on 7/17/19.
//  Copyright © 2019 CC. All rights reserved.
//

import Foundation

class BKError: Error {
    
    var description: String
    
    init(description: String){
        self.description = description
    }
}

extension BKError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(description, comment: "")
    }
}
