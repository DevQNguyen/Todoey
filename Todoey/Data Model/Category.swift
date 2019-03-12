//
//  Category.swift
//  Todoey
//
//  Created by Quang  Nguyen on 2/19/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    // Initialize a List (realm term for a type of container) of Item objects
    let items = List<Item>()
    
}
