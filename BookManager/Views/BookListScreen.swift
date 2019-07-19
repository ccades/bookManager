//
//  ViewController.swift
//  BookManager
//
//  Created by CC on 7/17/19.
//  Copyright © 2019 CC. All rights reserved.
//

import UIKit
import RealmSwift

class BookListScreen: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate,
    UIScrollViewDelegate,
    UITabBarControllerDelegate,
    BookViewDelegate
{
    
    let tableView = UITableView()
    var searchBar: UIView?
    var searchBarTextField: UITextField?
    let cellId = BK_CELL_ID
    var menuOptions = [UIButton]()
    var menuButton: UIButton?
    var chosenFilter = BK_PARAM_ANY
    var selectedScreen = ""
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
        
        // set tabBar delegate
        tabBarController?.delegate = self
        
        if selectedScreen != BK_SEL_SCREEN_BOOKS {
            bookPresenter.presentSearchedBooks(query: BK_QUERY_WISH, param: "")
        }
        
        // conform to bookViewDelegate
        bookPresenter.setViewDelegate(bookViewDelegate: self)
        view.backgroundColor = .white
        setupLayout()
    }
    
    // MARK: - Setup Methods
    
    func setupLayout() {
        
        // MARK: - Create Drop Down Menu
        
        let dropDownMenuStack = UIStackView()
        
        if selectedScreen == BK_SEL_SCREEN_BOOKS {
        
            // define search param buttons
            menuButton = UIButton(type: .system)
            guard let menuButton = menuButton else { return }
            menuButton.setTitle(BK_SEARCH_MENU_ANY, for: .normal)
            menuButton.backgroundColor = .darkGray
            let anyButton = UIButton(type: .system)
            anyButton.setTitle(BK_SEARCH_MENU_ANY, for: .normal)
            let titleButton = UIButton(type: .system)
            titleButton.setTitle(BK_SEARCH_MENU_TITLE, for: .normal)
            let authorButton = UIButton(type: .system)
            authorButton.setTitle(BK_SEARCH_MENU_AUTHOR, for: .normal)
            let dropDownButtons = [menuButton, anyButton, titleButton, authorButton]
            
            // add action to buttons
            menuButton.addTarget(self, action: #selector(menuDropDownAction), for: .touchUpInside)
            anyButton.addTarget(self, action: #selector(menuOptionAction), for: .touchUpInside)
            titleButton.addTarget(self, action: #selector(menuOptionAction), for: .touchUpInside)
            authorButton.addTarget(self, action: #selector(menuOptionAction), for: .touchUpInside)
            
            menuOptions = [anyButton, titleButton, authorButton]
            
            // hide option buttons initially
            menuOptions.forEach { (button) in
                button.backgroundColor = .lightGray
                button.isHidden = true
            }
            
            // set constraints on each button
            dropDownButtons.forEach { (button) in
                button.setTitleColor(.white, for: .normal)
                button.layer.cornerRadius = 5
                button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }
            
            // create drop down stack
            dropDownMenuStack.addArrangedSubview(menuButton)
            dropDownMenuStack.addArrangedSubview(anyButton)
            dropDownMenuStack.addArrangedSubview(titleButton)
            dropDownMenuStack.addArrangedSubview(authorButton)
            view.addSubview(dropDownMenuStack)
            dropDownMenuStack.axis = .vertical
            dropDownMenuStack.distribution = .fillEqually
            dropDownMenuStack.spacing = 2
            dropDownMenuStack.widthAnchor.constraint(equalToConstant: 60).isActive = true
            dropDownMenuStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0))
        
            // MARK: - Create SearchBar
            
            // define inner text view
            searchBarTextField = UITextField()
            guard let searchBarTextField = searchBarTextField else { return }
            searchBarTextField.returnKeyType = .done
            searchBarTextField.delegate = self
            
            // add textField to searchBar view
            searchBar = UIView()
            guard let searchBar = searchBar else { return }
            searchBar.addSubview(searchBarTextField)
            view.addSubview(searchBar)
            searchBar.backgroundColor = .white
            
            // add constraints to searchBar and textField
            searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
            searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: dropDownMenuStack.trailingAnchor, bottom: nil, trailing: view.trailingAnchor)
            searchBarTextField.anchor(top: searchBar.topAnchor, leading: searchBar.leadingAnchor, bottom: searchBar.bottomAnchor, trailing: searchBar.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15))
            
            searchBarTextField.layer.cornerRadius = 6
            searchBarTextField.placeholder = BK_SEARCHBAR_PLACEHOLDER
            searchBarTextField.backgroundColor = .lightGray
            searchBarTextField.tintColor = .darkGray
            searchBarTextField.textColor = .darkGray
            
            // pad the left side of the textField
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: searchBarTextField.frame.height))
            searchBarTextField.leftView = paddingView
            searchBarTextField.leftViewMode = .always
        }
        
        // MARK: - Create TableView
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // register cell
        tableView.register(BookCell.self, forCellReuseIdentifier: cellId)
        
        // add constraints to tableView
        if selectedScreen == BK_SEL_SCREEN_BOOKS {
            tableView.anchor(top: dropDownMenuStack.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        } else {
            tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        }

    }
    
    // PRESENTER DELEGATE METHOD
    func didGetResults() {
        tableView.reloadData()
    }

    // MARK: - DropDown Methods
    
    func hideMenuButtons() {
        menuOptions.forEach { (button) in
            UIView.animate(withDuration: 0.25, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func menuDropDownAction() {
        hideMenuButtons()
    }
    
    @objc func menuOptionAction(sender: UIButton) {
        menuButton?.setTitle(sender.titleLabel?.text, for: .normal)
        guard let lblText = sender.titleLabel?.text else { return }
        if lblText == BK_SEARCH_MENU_ANY {
            chosenFilter = BK_PARAM_ANY
        } else if lblText == BK_SEARCH_MENU_TITLE {
            chosenFilter = BK_PARAM_TITLE
        } else if lblText == BK_SEARCH_MENU_AUTHOR {
            chosenFilter = BK_PARAM_AUTHOR
        }
        guard let text = searchBarTextField?.text else { return }
        if text.count > 0 {
            bookPresenter.presentSearchedBooks(query: text, param: chosenFilter)
        }
        hideMenuButtons()
    }
    
    // MARK: - TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookPresenter.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BookCell
        
        
        if let coverImg = bookPresenter.books[indexPath.row].coverImageURL {
            if coverImg.count > (BK_COVER_IMAGE_BASE_URL + BK_COVER_IMAGE_M).count {
                cell.bookImageView.loadImageUsingCacheWithUrlString(urlString: coverImg)
            } else {
                cell.bookImageView.image = #imageLiteral(resourceName: "EmptyBook")
            }
        }
        
        if let title = bookPresenter.books[indexPath.row].title {
            cell.textLabel?.text = title
        }
        if let author = bookPresenter.books[indexPath.row].author {
            if author.count > 0 {
                cell.detailTextLabel?.text = author[0]
            } else {
                cell.detailTextLabel?.text = BK_UNKNOWN_AUTHOR
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController(service: WishListService())
        detailsVC.book = bookPresenter.books[indexPath.row]
        self.present(detailsVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // slide to delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if selectedScreen != BK_SEL_SCREEN_BOOKS {
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                guard let key = self.bookPresenter.books[indexPath.row].bookKey else { return }
                self.bookPresenter.removeBookFromWishlist(key: key)
            }
            delete.backgroundColor = .red
            return [delete]
        } else {
            return []
        }
    }
    
    // MARK: - TextField Methods
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // update so that it reflects the current text in textField
        let previousText:NSString = textField.text! as NSString
        let updatedText = previousText.replacingCharacters(in: range, with: string)
        if updatedText.count > 0 {
            // search
            bookPresenter.presentSearchedBooks(query: updatedText, param: chosenFilter)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // MARK: - ScrollView Methods
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // MARK: TabBar Methods
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedScreen != BK_SEL_SCREEN_BOOKS {
            bookPresenter.presentSearchedBooks(query: BK_QUERY_WISH, param: chosenFilter)
        }
    }
}
