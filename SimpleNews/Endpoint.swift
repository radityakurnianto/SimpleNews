//
//  Endpoint.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/28/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import Foundation

public typealias Parameters = [String: String]

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nytimes.com"
        components.path = "/svc/" + path
        components.queryItems = queryItems
        
        return components.url
    }
}

extension Endpoint {
    static func getNewsfeed(param: Parameters) -> Endpoint {
        return Endpoint(path: "news/v3/content/all/all.json", queryItems: queryItems(param: param))
    }
    
    static func searchNews(param: Parameters) -> Endpoint {
        return Endpoint(path: "search/v2/articlesearch.json", queryItems: queryItems(param: param))
    }
    
    static func queryItems(param: Parameters) -> [URLQueryItem] {
        return param.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
}
