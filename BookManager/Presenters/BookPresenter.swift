//
//  BookPresenter.swift
//  BookManager
//
//  Created by CC on 7/18/19.
//  Copyright © 2019 CC. All rights reserved.
//

protocol BookViewDelegate: NSObjectProtocol {
    func didGetResults()
}

import Foundation

class BookPresenter {
    
    // query cache in case API calls are an issue
//    private var queryCache = [String:[Book]]()
    private let bookService: BookService
    private var currentBooks = [Book]()
    private var currentWishList = [WishListBook]()
    public var books: [Book] {
        return currentBooks
    }
    
    weak private var bookViewDelegate : BookViewDelegate?
    
    // custom init injecting bookService
    init(bookService: BookService){
        self.bookService = bookService
    }
    
    func setViewDelegate(bookViewDelegate: BookViewDelegate?){
        self.bookViewDelegate = bookViewDelegate
    }
    
    func setCurrent(books: [Book]) {
        currentBooks = books
        bookViewDelegate?.didGetResults()
    }
    
    func convertBookToWishListBook(book: Book) -> WishListBook {
        let wishListBook = WishListBook()
        if let authors = book.author {
            if authors.count > 0 {
                for author in authors {
                    wishListBook.author.append(author)
                }
            } else {
                wishListBook.author.append(BK_UNKNOWN_AUTHOR)
            }
        }
        wishListBook.bookKey = book.bookKey
        wishListBook.coverImageURL = book.coverImageURL
        if let subjects = book.subject {
            if subjects.count > 0 {
                for subject in subjects {
                    wishListBook.subject.append(subject)
                }
            }
        }
        wishListBook.title = book.title
        return wishListBook
    }
    
    // MARK: - CRUD Methods
    
    // add book
    func addBookToWishlist(book: Book) {
        var hasBook = false
        for bk in books {
            if bk.bookKey == book.bookKey {
                hasBook = true
            }
        }
        if hasBook != true {
            let wishListBook = convertBookToWishListBook(book: book)
            bookService.addBook(book: wishListBook)
        }
    }
    
    // remove book
    func removeBookFromWishlist(key: String) {
        bookService.removeBook(key: key)
        self.presentSearchedBooks(query: BK_QUERY_WISH, param: "")
    }
    
    // get books
    func presentSearchedBooks(query: String, param: String) {
//        if queryCache[param+query] != nil && query != BK_QUERY_WISH {
//            guard let queryBooks = queryCache[param+query] else { return }
//            setCurrent(books: queryBooks)
//            return
//        }
        if query == BK_QUERY_WISH {
            bookService.getBooks(query: query, param: param).done { [weak self] (books) in
                self?.setCurrent(books: books)
                }.catch { (err) in
                    print("ERROR", err.localizedDescription)
            }
        }
        bookService.getBooks(query: query, param: param).done { [weak self] (books) in
//            self?.queryCache[query] = books
            self?.setCurrent(books: books)
        }.catch { (err) in
            print("ERROR", err.localizedDescription)
        }
    }
}
