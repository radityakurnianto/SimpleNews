//
//  DetailContentViewModel.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/29/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class DetailContentViewModel: NSObject {
    
    override init() {
        // do nothing
    }
    
    func bookmark(news: News, completed:(@escaping(_ msg: String)->Void)) -> Void {
        var message = ""
        var result = false
        
        if news.isBookmark {
            result = NewsOperation.shared.removeBookmark(news: news)
            message = result ? "Successfully removed from Bookmark" : "Failed removed from Bookmark"
        } else {
            result = NewsOperation.shared.duplicateNews(news: news)
            message = result ? "Successfully added to Bookmark" : "Failed added to Bookmark"
        }
        
        NewsOperation.shared.update(news: news)
        completed(message)
    }
}
