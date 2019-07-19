//
//  WishListService.swift
//  BookManager
//
//  Created by CC on 7/18/19.
//  Copyright © 2019 CC. All rights reserved.
//

import Foundation
import RealmSwift
import PromiseKit

class WishListService: BookService {
    
    var realm = try! Realm()
    
    func addBook(book: WishListBook) {
        do {
            try realm.write {
                realm.add(book)
            }
        } catch {
            print(error)
        }
    }
    
    func getBooks(query: String, param: String) -> Promise<[Book]> {
        return Promise { seal in
            var returnedBooks = [Book]()
            let wishListBooks = realm.objects(WishListBook.self)
            wishListBooks.forEach({ (wBook) in
                var book = Book()
                book.title = wBook.title
                book.coverImageURL = wBook.coverImageURL
                book.bookKey = wBook.bookKey
                book.author = Array(wBook.author)
                book.subject = Array(wBook.subject)
                returnedBooks.append(book)
            })
            seal.fulfill(returnedBooks)
        }
    }
    
    func removeBook(key: String) {
        do {
            let bookToDelete = realm.objects(WishListBook.self).filter("bookKey = '\(key)'")
            try realm.write {
                realm.delete(bookToDelete)
            }
        } catch {
            print(error)
        }
    }
}
