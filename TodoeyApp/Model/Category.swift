//
//  Category.swift
//  TodoeyApp
//
//  Created by Battal Uçar on 8.11.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = "New Category"
    
    let items = List<Item>()
}
