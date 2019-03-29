//
//  News+CoreDataProperties.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/29/19.
//  Copyright © 2019 raditya. All rights reserved.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var date: String?
    @NSManaged public var identifier: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var newsUrl: String?
    @NSManaged public var snippet: String?
    @NSManaged public var title: String?
    @NSManaged public var isBookmark: Bool

}
