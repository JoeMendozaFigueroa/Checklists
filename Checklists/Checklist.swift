//
//  Checklist.swift
//  Checklists
//
//  Created by Josue Mendoza on 9/6/21.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
