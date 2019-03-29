//
//  DetailPageViewController.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/27/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class DetailPageViewController: UIPageViewController {

    var numberOfPages: Int?
    var currentPageIndex: Int?
    var parentController: DetailParentController?
    var news: [News]?
    var onCompleteTransition:((News)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
    }
    

    //MARK: View controller
    func viewControllerAtIndex(index: Int) -> DetailContentController? {
        if numberOfPages! == 0 || index >= numberOfPages! { return nil }
        
        guard let page = self.storyboard?.instantiateViewController(withIdentifier: String(describing: DetailContentController.self)) as? DetailContentController else { return nil }
    
        page.pageIndex = index
        if let collection = news {
            page.news = collection[index]
        }
        page.view.frame = self.view.bounds
        
        return page
    }
    
    //MARK: Public function
    func scrollPageTo(idx: Int) -> Void {
        if parentController == nil {
            parentController = self.parent as? DetailParentController
        }
        
        if currentPageIndex != idx {
            let firstPage = self.viewControllerAtIndex(index: idx)
            
            if currentPageIndex ?? 0 < idx {
                self.setViewControllers([firstPage!], direction: .forward, animated: false, completion: nil)
            } else {
                self.setViewControllers([firstPage!], direction: .reverse, animated: false, completion: nil)
            }
            currentPageIndex = idx
        } else {
            let firstPage = self.viewControllerAtIndex(index: idx)
            self.setViewControllers([firstPage!], direction: .reverse, animated: false, completion: nil)
        }
    }
}

extension DetailPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! DetailContentController).pageIndex
        if index == 0 || index == NSNotFound { return nil }
        let i = index! - 1
        
        return self.viewControllerAtIndex(index: i)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! DetailContentController).pageIndex
        
        if index == NSNotFound { return nil }
        
        let i = index! + 1
        if index == numberOfPages { return nil }
        
        return self.viewControllerAtIndex(index: i)
    }
}

extension DetailPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            
        }
    }
}
