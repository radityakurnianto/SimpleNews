//
//  DetailParentController.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/27/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class DetailParentController: UIViewController {

    var pageController: DetailPageViewController?
    var pageCount = 0
    var selectedIndex = 0
    var news: [News]?
    var bookmarkButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageView()
        
        bookmarkButton = UIBarButtonItem(image: UIImage(named: "bookmark"), style: .plain, target: self, action: #selector(bookmarkContent))
        self.navigationItem.rightBarButtonItem = bookmarkButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "childViewStoryboard" {
            let homePageView = segue.destination as! DetailPageViewController
            pageController = homePageView
            pageController?.news = news
        }
    }
    
    func setupPageView() -> Void {
        pageController?.numberOfPages = pageCount
        pageController?.scrollPageTo(idx: selectedIndex)
    }
    
    @objc func bookmarkContent() -> Void {
        guard let contentController = pageController?.viewControllers?.last as? DetailContentController else { return }
        contentController.bookmark()
    }
}
