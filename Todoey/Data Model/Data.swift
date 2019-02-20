//
//  File.swift
//  Todoey
//
//  Created by Quang  Nguyen on 2/19/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import Foundation
import RealmSwift


// 2Realm. Declare a class with superclass of Object with properties
class Data: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
