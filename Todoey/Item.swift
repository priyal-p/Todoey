//
//  Item.swift
//  Todoey
//
//  Created by Priyal PORWAL on 16/03/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

class Item: Codable {
    var title: String
    var completionStatus: Bool

    init(title: String, completionStatus: Bool = false) {
        self.title = title
        self.completionStatus = completionStatus
    }
}
