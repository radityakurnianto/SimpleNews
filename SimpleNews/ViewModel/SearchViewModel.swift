//
//  SearchViewModel.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/28/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {
    var task: URLSessionDataTask!
    var taskIsRunning = false
    var newsArray:[News]?
    
    override init() {
        newsArray = Array()
    }
    
    func purgeOldSearchResult() -> Void {
        NewsOperation.shared.removeAll(identifier: "Search")
    }
    
    func searchNews(keyword: String, finishLoad:@escaping ()->Void) -> Void {
        if taskIsRunning { return }
        
        let param = ["api-key": "7Wgb3JadLSrCERXE2JbpVGlNA0ajrDEn",
                     "q":keyword]
        
        task = Api.search(.searchNews(param: param), completion: { [weak self] (collection, error) in
            guard let result = collection else { return }
            self?.newsArray?.removeAll()
            
            self?.newsArray = result
            self?.taskIsRunning = false
            finishLoad()
        })
        
        taskIsRunning = true
    }
}
