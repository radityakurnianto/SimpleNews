//
//  NewsOperation.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/28/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewsOperation: Parserable {
    static let shared = NewsOperation()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Couldn't initiate app delegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.mergePolicy = NSOverwriteMergePolicy
        
        return context
    }()
    
    fileprivate init() {
        // do nothing
    }
    
    func saveNews(news: [String: Any], identifier: String) -> Void {
        guard let json = parseJson(data: news) else {
            fatalError("JSON is not parselable")
        }
        
        guard let items = json.results as? [[String: Any]] else { return }
        
        for item in items {
            guard let newsEntity = NSEntityDescription.insertNewObject(forEntityName: "News", into: managedObjectContext) as? News else {
                fatalError("Entity 'News' can't be found")
            }
            
            guard let newsItem = parseJson(data: item) else { return }
            
            guard let title = newsItem.title as? String else { return }
            guard let snippet = newsItem.abstract as? String else { return }
            guard let date = newsItem.published_date as? String else { return }
            guard let imageUrl = newsItem.thumbnail_standard as? String else { return }
            guard let newsUrl = newsItem.url as? String else { return }
            
            newsEntity.title = title
            newsEntity.snippet = snippet
            newsEntity.date = date
            newsEntity.imageUrl = imageUrl
            newsEntity.newsUrl = newsUrl
            newsEntity.identifier = identifier
            newsEntity.isBookmark = false
        }
        
        do {
            try managedObjectContext.save()
        } catch (let error) {
            print("Failed to save news with error \(error)")
        }
    }
    
    func saveSearchNews(news: [String: Any], identifier: String) -> Void {
        guard let json = parseJson(data: news) else {
            fatalError("JSON is not parselable")
        }
        
        guard let response = json.response as? [String: Any] else { return }
        guard let jsondocs = parseJson(data: response) else { return }
        guard let items = jsondocs.docs as? [[String: Any]] else { return }
        
        for item in items {
            guard let newsEntity = NSEntityDescription.insertNewObject(forEntityName: "News", into: managedObjectContext) as? News else {
                fatalError("Entity 'News' can't be found")
            }
            
            guard let newsItem = parseJson(data: item) else { return }
            guard let headline = parseJson(data: newsItem.headline) else { return }
            
            if let title = headline.main as? String {
                newsEntity.title = title
            }
            
            if let snippet = newsItem.snippet as? String {
                newsEntity.snippet = snippet
            }
            
            if let date = newsItem.pub_date as? String {
                newsEntity.date = date
            }
            
            guard let media = newsItem.multimedia as? [[String: Any]] else { return }
            
            if media.count > 0 {
                if let firstItem = media.first, let object = parseJson(data: firstItem), let mediUrl = object.url as? String {
                    newsEntity.imageUrl = "https://static01.nyt.com/" + mediUrl
                }
            }
            
            if let newsUrl = newsItem.web_url as? String {
                newsEntity.newsUrl = newsUrl
            }
            
            newsEntity.identifier = identifier
            newsEntity.isBookmark = false
        }
        
        do {
            try managedObjectContext.save()
            print("search_saved")
        } catch (let error) {
            print("Failed to save news with error \(error)")
        }
    }
    
    func duplicateNews(news: News) -> Bool {
        guard let newsEntity = NSEntityDescription.insertNewObject(forEntityName: "News", into: managedObjectContext) as? News else {
            fatalError("Entity 'News' can't be found")
        }
        
        newsEntity.title = news.title
        newsEntity.snippet = news.snippet
        newsEntity.date = news.date
        newsEntity.imageUrl = news.imageUrl
        newsEntity.newsUrl = news.newsUrl
        newsEntity.identifier = "Bookmark"
        newsEntity.isBookmark = true
        
        
        do {
            try managedObjectContext.save()
            print("duplicateNews")
            return true
        } catch (let error) {
            print("Failed to save news with error \(error)")
            return false
        }
    }
    
    func getAllNews(identifier: String) -> [News]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        do {
            let result = try managedObjectContext.fetch(request) as? [News]
            print("result_for identifier \(identifier) = \(result!.count)")
            return result
        } catch (let error) {
            print("Failed to obtain data from 'News' with error \(error)")
        }
        
        return nil
    }
    
    func update(news: News) -> Void {
        news.isBookmark = !news.isBookmark
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to update news with error \(error)")
        }
        
    }
    
    func removeAll(identifier: String) -> Void {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(deleteRequest)
        } catch {
            print("Failed to purge core data")
        }
    }
    
    func removeBookmark(news: News) -> Bool {
        guard let url = news.newsUrl else {
            fatalError("No url found. Can't proceed to delete")
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "identifier = %@ AND newsUrl = %@", "Bookmark", url)
        
        do {
            guard let result = try managedObjectContext.fetch(request) as? [News] else { return false }
            for item in result {
                managedObjectContext.delete(item)
            }
            
            try managedObjectContext.save()
            print("remove_bookmark_success")
            return true
        } catch {
            print("remove_bookmark_failed \(error)")
            return false
        }
    }
    
    func parseJson(data: [String : Any]?) -> JSONParser? {
        guard let json = data else { return nil }
        return JSONParser(dict: json)
    }
}
