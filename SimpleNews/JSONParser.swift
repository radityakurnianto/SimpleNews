//
//  JSONParser.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/28/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import Foundation

@dynamicMemberLookup struct JSONParser {
    let dict: [String: Any]
    
    subscript(dynamicMember member: String) -> Any? {
        return dict[member]
    }
    
    subscript<T> (dynamicMember member: String) -> T? {
        return dict[member] as? T
    }
}

protocol Parserable {
    func parseJson(data: [String: Any]?) -> JSONParser?
}
