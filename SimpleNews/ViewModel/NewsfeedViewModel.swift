//
//  NewsfeedViewModel.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/27/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class NewsfeedViewModel: NSObject {

    var offset = 0
    var limit = 10
    var task: URLSessionDataTask!
    var taskIsRunning = false
    var newsArray:[News]?
    
    override init() {
        newsArray = Array()
    }
    
    func purgeOldNewsfeed() -> Void {
        NewsOperation.shared.removeAll(identifier: "Feed")
    }
    
    func refreshPage() -> Void {
        offset = 0
        purgeOldNewsfeed()
    }
    
    func getNews(finishLoad:@escaping ()->Void) -> Void {
        if taskIsRunning { return }
        
        let param = ["offset": String(offset),
                     "limit": String(limit),
                     "api-key": "7Wgb3JadLSrCERXE2JbpVGlNA0ajrDEn"]

        task = Api.newsfeed(.getNewsfeed(param: param), completion: { [weak self] (collection, error) in
            self?.taskIsRunning = false
            
            if error != nil {
                if self?.offset == 0 {
                    guard let result = NewsOperation.shared.getAllNews(identifier: "Feed") else { return }
                    self?.newsArray?.removeAll()
                    self?.newsArray = result
                    
                    finishLoad()
                    return
                }
            }
            
            if self?.offset == 0 {
                self?.purgeOldNewsfeed()
            }
            
            guard let result = collection else { return }
            self?.newsArray?.removeAll()
            
            self?.newsArray = result
            self?.offset = (self?.offset)! + 10
            finishLoad()
        })
        taskIsRunning = true
    }
    
    
}
