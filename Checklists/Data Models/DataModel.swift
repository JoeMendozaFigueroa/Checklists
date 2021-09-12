//
//  DataModel.swift
//  Checklists
//
//  Created by Josue Mendoza on 9/7/21.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    var indexOfSelectedChecklist: Int{
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    func registerDefaults() {
        let dictionary = [ "ChecklistIndex": -1, "FirstTime": true]
        as [String:Any]
        UserDefaults.standard.register(defaults:dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    //MARK: - DATA SAVING
    //This method creates a "Documents Directory" for where the contents of your App will be stored.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        return paths [0]
    }
    //This method creates the "Checklists.plist" file into the Document window, where it saves the changes you make to the current status of the app.
    func dataFilePath() -> URL {
        return documentsDirectory() .appendingPathComponent("Checklists.plist")
        
    }
    //This method converts the text into binary data, then saves it to a file inside the documents folder from above.
    func  saveChecklists() {
        let encoder = PropertyListEncoder()
        //This section of the code takes any errors that may occur and writes them to the Debug screen.
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    //This method reloads the saved data from "Checklists.plist" file.
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path)
        {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode(
                    [Checklist].self,from: data)
                sortChecklists()
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    //This method comapres one list of itme to the other and sorts them out Alphabetically
    func sortChecklists() {
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
}
