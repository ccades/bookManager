//
//  TabBarController.swift
//  BookManager
//
//  Created by CC on 7/17/19.
//  Copyright © 2019 CC. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let booksViewController = BookListScreen(service: OpenLibraryService())
        booksViewController.selectedScreen = BK_SEL_SCREEN_BOOKS
        booksViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        booksViewController.title = BK_TAB_BOOKS
        
        let wishListViewController = BookListScreen(service: WishListService())
        wishListViewController.selectedScreen = BK_SEL_SCREEN_WISH
        wishListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        wishListViewController.title = BK_TAB_WISHLIST
        
        let tabBarList = [booksViewController, wishListViewController]
        viewControllers = tabBarList
    }
}
