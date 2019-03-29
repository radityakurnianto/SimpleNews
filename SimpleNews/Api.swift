//
//  Api.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/28/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import Foundation

class Api {
    class func newsfeed(_ endpoint: Endpoint, completion:@escaping (_ result: [News]?,_ error: Error?)->Void) -> URLSessionDataTask? {
        guard let url = endpoint.url else { return nil }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, error)
                print("data invalid")
                return
            }
            
            do {
                guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("json invalid")
                    completion(nil, error)
                    return
                }
                
                
                DispatchQueue.main.async {
                    NewsOperation.shared.saveNews(news: jsonResponse, identifier: "Feed")
                    guard let result = NewsOperation.shared.getAllNews(identifier: "Feed") else { return }
                    completion(result, nil)
                }
                
            } catch {
                print("json invalid \(error)")
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    
    class func search(_ endpoint: Endpoint, completion:@escaping (_ result: [News]?,_ error: Error?)->Void) -> URLSessionDataTask? {
        guard let url = endpoint.url else { return nil }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                print("data invalid")
                completion(nil, error)
                return
            }
            
            do {
                guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("json invalid")
                    completion(nil, error)
                    return
                }
                
                
                DispatchQueue.main.async {
                    NewsOperation.shared.saveSearchNews(news: jsonResponse, identifier: "Search")
                    guard let result = NewsOperation.shared.getAllNews(identifier: "Search") else { return }
                    completion(result, nil)
                }
                
            } catch {
                print("json invalid \(error)")
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
}
