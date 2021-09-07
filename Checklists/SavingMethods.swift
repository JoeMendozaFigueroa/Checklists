//
//  SavingMethods.swift
//  Checklists
//
//  Created by Josue Mendoza on 9/6/21.
//

import UIKit

/*
//This method creates a "Documents Directory" for where the contents of your App will be stored.
func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(
        for: .documentDirectory, in: .userDomainMask)
    return paths [0]
}
//This method creates the "Checklists.plist" file into the Document window, where it saves the changes you make to the current status of the app.
func dataFilePath() -> URL {
    return documentsDirectory()
        .appendingPathComponent("Checklists.plist")
    
}
//This method converts the text into binary data, then saves it to a file inside the documents folder from above.
func  {
    let encoder = PropertyListEncoder()
    //This section of the code takes any errors that may occur and writes them to the Debug screen.
    do {
        let data = try encoder.encode(checklist.items)
        try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
    } catch {
        print("Error encoding item array: \(error.localizedDescription)")
    }
}
//This method reloads the saved data from "Checklists.plist" file.
func loadChecklistItems() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path)
    {
        let decoder = PropertyListDecoder()
        do {
            checklist.items = try decoder.decode(
                [ChecklistItem].self,from: data)
        } catch {
            print("Error decoding item array: \(error.localizedDescription)")
        }
    }
}
*/
