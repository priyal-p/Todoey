//
//  Item.swift
//  Todoey
//
//  Created by Priyal PORWAL on 30/03/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var completionStatus: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")// Define inverse relationship with category
}
