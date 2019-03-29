//
//  BookmarkViewModel.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/29/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class BookmarkViewModel: NSObject {
    var newsArray:[News]?
    
    override init() {
        newsArray = Array()
    }
    
    func getBookmark(finishLoad:@escaping ()->Void) -> Void {
        newsArray?.removeAll()
        guard let collection = NewsOperation.shared.getAllNews(identifier: "Bookmark") else { return }
        newsArray = collection
        finishLoad()
    }
}
