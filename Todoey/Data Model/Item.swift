//
//  Item.swift
//  Todoey
//
//  Created by Quang  Nguyen on 2/19/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    // Initialize an object linked to the parent category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
