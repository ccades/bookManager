//
//  BookService.swift
//  BookManager
//
//  Created by CC on 7/17/19.
//  Copyright © 2019 CC. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class OpenLibraryService: BookService {
    
    let basePath = BK_BASE_PATH
    
    func getBooks(query: String, param: String) -> Promise<[Book]> {
        return Promise { seal in
            let params: [String: Any] = [
                param: query,
            ]
            // Alamofire request and validation, with resopnse serialize into JSON
            Alamofire.request(basePath,
                              method: .get,
                              parameters: params,
                              encoding: URLEncoding.default
                ).validate().responseJSON { response in
                // Check to make sure request is successful
                if response.response?.statusCode != nil  {
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 200:
                            
                            if let bookDTOs = JSON(response.result.value!)[BK_DOCS].array {
                                
                                seal.fulfill(self.convertBookDTOsToBooks(bookDTOs: bookDTOs))
                            } else {
                                seal.reject(BKError(description: "GetBooks response DTOs unwrap error"))
                            }
                        case 401:
                            seal.reject(BKError(description: "GetBooks Status Code \(statusCode) Unauthorized"))
                        case 403:
                            seal.reject(BKError(description: "GetBooks Status Code \(statusCode) Forbidden"))
                        case 404:
                            seal.reject(BKError(description: "GetBooks Status Code \(statusCode) Not Found"))
                        default:
                            seal.reject(BKError(description: "GetBooks Status Code \(statusCode) Server Error")) // 500 errors
                        }
                    } else {
                        seal.reject(BKError(description: "Error getBooks request: \(String(describing: response.result.error))"))
                    }
                }
            }
        }
    }
    
    func convertBookDTOsToBooks(bookDTOs: [JSON]) -> [Book]{
        var books = [Book]()
        for bookDTO in bookDTOs {
            var book = Book()
            book.title = bookDTO[BK_KEY_TITLE].stringValue
            
            var authors = [String]()
            bookDTO[BK_KEY_AUTHOR].array?.forEach({ (author) in
                authors.append(author.stringValue)
            })
            book.author = authors
            
            var subjects = [String]()
            bookDTO[BK_KEY_SUBJECT].array?.forEach({ (subject) in
                subjects.append(subject.stringValue)
            })
            book.subject = subjects
            book.coverImageURL = BK_COVER_IMAGE_BASE_URL + bookDTO[BK_COVER_IMAGE].stringValue + BK_COVER_IMAGE_M
            book.bookKey = bookDTO[BK_KEY].stringValue
            books.append(book)
        }
        return books
    }
    
    func addBook(book: WishListBook) {
    }
    
    func removeBook(key: String) {
    }
}
