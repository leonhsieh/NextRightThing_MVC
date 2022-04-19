//
//  Item.swift
//  ToDoList
//
//  Created by leon on 2022/3/15.
//

import Foundation
import RealmSwift



class Item: Object {   
    
    @Persisted var title: String = ""
    @Persisted var dateCreated: Date?
    @Persisted var done: Bool = false
    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<ToDoCategory>
        
}
