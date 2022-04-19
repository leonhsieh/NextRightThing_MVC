//
//  Category.swift
//  ToDoList
//
//  Created by leon on 2022/3/15.
//

import Foundation
import RealmSwift

class ToDoCategory: Object{
    @Persisted var name: String = ""    
    @Persisted var items = List<Item>()    
}
