//
//  Data.swift
//  Todoey
//
//  Created by Priyal PORWAL on 24/03/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object { // Object is a class used to define Realm model objects
    // dynamic here is a declaration modifier, to tell runtime to use dynamic dispatch over the standard static dispatch. This way this property name would be monitored for change at runtime.but dynamic dispatch comes from the objc APIs, so we have to mark that we are using the objective c runtime using @objc
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
