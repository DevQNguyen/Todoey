//
//  Item.swift
//  Todoey
//
//  Created by Quang  Nguyen on 1/9/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import Foundation

//Declare class with protocol conforming to Codable
class Item: Codable {
    
    //Declare data model variables
    var title: String = ""
    var done: Bool = false
    
}
