//
//  Checklist.swift
//  Checklists
//
//  Created by Josue Mendoza on 9/6/21.
//

import UIKit

//This is the class for items on the checklist. The created text and the icons selected.
class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    var  iconName = "No Icon"
    
    //This method is for the icon list
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    //This method counts how many items have been checked/not-checked on the list
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
