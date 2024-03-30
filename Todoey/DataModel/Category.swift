//
//  Category.swift
//  Todoey
//
//  Created by Priyal PORWAL on 30/03/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() // Defines relationship between Category and Item
}
