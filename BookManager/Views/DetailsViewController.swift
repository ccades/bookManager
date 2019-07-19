//
//  DetailsViewController.swift
//  BookManager
//
//  Created by CC on 7/17/19.
//  Copyright © 2019 CC. All rights reserved.
//

import UIKit
import RealmSwift

class DetailsViewController: UIViewController, BookViewDelegate {
    
    var book: Book?
    private let bookPresenter: BookPresenter
    
    // Custom init with service
    init(service: BookService) {
        bookPresenter = BookPresenter(bookService: service)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // conform to bookViewDelegate
        bookPresenter.setViewDelegate(bookViewDelegate: self)
        view.backgroundColor = .white
        setupLayout()
        
    }
    
    func setupLayout() {
        
        // create back button
        let backButton = UIButton()
        view.addSubview(backButton)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), size: CGSize(width: 50, height: 50))
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        // create add to wish list button
        let wishListButton = UIButton()
        view.addSubview(wishListButton)
        wishListButton.setTitle("Wish List", for: .normal)
        wishListButton.setTitleColor(.black, for: .normal)
        wishListButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), size: CGSize(width: 90, height: 50))
        wishListButton.addTarget(self, action: #selector(addToWishList), for: .touchUpInside)
        
        // book cover image and details
        let bookCoverImage = UIImageView()
        let detailText = UITextView()
        detailText.heightAnchor.constraint(equalToConstant: 80).isActive = true
        detailText.font = UIFont(name: "Avenir Next", size: 25)
        let authors = UITextView()
        authors.font = UIFont(name: "Avenir Next", size: 18)
        authors.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let subjects = UITextView()
        subjects.font = UIFont(name: "Avenir Next", size: 13)
        
        detailText.text = book?.title
        
        var authorString = ""
        guard let allAuthors = book?.author else { return }
        allAuthors.forEach { (author) in
            if allAuthors.count > 1 {
                authorString += (author + ", ")
            } else {
                authorString += author
            }
        }
        authors.text = "By: " + authorString
        
        var subjectString = ""
        guard let allSubjects = book?.subject else { return }
        allSubjects.forEach { (subject) in
            if allSubjects.count > 1 {
                subjectString += (subject + ", ")
            } else {
                subjectString += subject
            }
        }
        subjects.text = "Subject: " + subjectString
        
        bookCoverImage.image?.withRenderingMode(.alwaysOriginal)
        bookCoverImage.contentMode = .scaleAspectFit
        guard let url = book?.coverImageURL else { return }
        if url.count > (BK_COVER_IMAGE_BASE_URL + BK_COVER_IMAGE_M).count {
            bookCoverImage.loadImageUsingCacheWithUrlString(urlString: url)
        } else {
            bookCoverImage.image = #imageLiteral(resourceName: "EmptyBook")
        }
        
        // description stack views
        let descriptionStackView = UIStackView(arrangedSubviews: [detailText, authors, subjects])
        descriptionStackView.axis = .vertical
        let fullPageStackView = UIStackView(arrangedSubviews: [bookCoverImage, descriptionStackView])
        view.addSubview(fullPageStackView)
        fullPageStackView.axis = .vertical
        fullPageStackView.anchor(top: backButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    // DELEGATE METHOD
    func didGetResults() {
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addToWishList() {
        guard let book = book else { return }
        bookPresenter.addBookToWishlist(book: book)
        self.dismiss(animated: true, completion: nil)
    }
    
}
