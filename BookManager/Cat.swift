//
//  Cat.swift
//  RealmDB
//
//  Created by CC on 7/17/19.
//  Copyright © 2019 CC. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object {
    @objc dynamic var name: String?
    @objc dynamic var color: String?
    @objc dynamic var gender: String?
}
