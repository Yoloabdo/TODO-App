//
//  TODOItem.swift
//  FitsMind
//
//  Created by abdelrahman mohamed on 9/3/17.
//  Copyright © 2017 abdelrahman mohamed. All rights reserved.
//

import Foundation
import RealmSwift




class TODOItem: Object {
    
    dynamic var id = Date().hashValue

    
    dynamic var text: String? = ""
    dynamic var dueDate: Date?
    dynamic var priority = false
    dynamic var lastUpdate = Date()
    dynamic var done = false
    
    convenience init(text: String?, dueDate: Date?, priority: Bool?) {
        self.init()
        self.text = text
        self.dueDate = dueDate
        self.priority = priority ?? false
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["text", "dueDate", "priority"]
    }

}
