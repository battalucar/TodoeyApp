//
//  Item.swift
//  TodoeyApp
//
//  Created by Battal Uçar on 8.11.2022.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = "New Item"
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
