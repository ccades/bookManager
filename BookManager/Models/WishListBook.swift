//
//  WishListBook.swift
//  BookManager
//
//  Created by CC on 7/17/19.
//  Copyright © 2019 CC. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class WishListBook: Object {
    
    @objc dynamic var title: String?
    let author = List<String>()
    let subject = List<String>()
    @objc dynamic var coverImageURL: String?
    @objc dynamic var bookKey: String?
}
