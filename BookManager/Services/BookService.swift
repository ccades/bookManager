//
//  BookService.swift
//  BookManager
//
//  Created by CC on 7/18/19.
//  Copyright © 2019 CC. All rights reserved.
//

import Foundation
import PromiseKit

protocol BookService {
    func getBooks(query: String, param: String) -> Promise<[Book]>
    func addBook(book: WishListBook)
    func removeBook(key: String)
}
