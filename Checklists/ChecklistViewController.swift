//
//  ViewController.swift
//  Checklists
//
//  Created by Josue Mendoza on 8/27/21.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    /*This is the variable that calls for the variables inside the "ChecklistItem.swift" file in the bundle.*/
    var items = [ChecklistItem]()
    
    var checklist: Checklist!
    
    /*This is the standard method that Xcode inserts when you start a new viewcontroller*/
    override func viewDidLoad() {
        super.viewDidLoad()
        //This syntex is so that the title of the navigation contoller has a standard style text.
        navigationItem.largeTitleDisplayMode = .never
        
        loadChecklistItems()
        
        /*The variables below are the contents inside each reusable cell inside the table view.*/
        let item1 = ChecklistItem()
        item1.text = "Walk the dog"
        items.append(item1)
        
        let item2 = ChecklistItem()
        item2.text = "Brush my teeth"
        items.append(item2)
        
        let item3 = ChecklistItem()
        item3.text = "Learn iOS development"
        items.append(item3)
        
        let item4 = ChecklistItem()
        item4.text = "Soccer practice"
        items.append(item4)
        
        let item5 = ChecklistItem()
        item5.text = "Eat ice cream"
        items.append(item5)
        
        //This will print unto the Debug Screen
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
        
        title = checklist.name
    }
    /*This is the method for for when a user selects or deselcts the checkmark label.*/
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem)
    {
        let label = cell.viewWithTag(1001) as! UILabel //This variable identifies the checkmark label
        
        if item.checked {
            label.text = "✓"
            } else {
                label.text = ""
            }
        }
    /*This is the method to identify the "edit item" button which is the "detail disclosure" icon*/
    func configureText(for cell: UITableViewCell, with item: ChecklistItem)
    {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
  
    //MARK: - Navigation
    /*This method is for the segue of the View Controller which lets you Add/Edit an item. Depending on the selection of the user. The Boolean will either change the title to "AddItem" or "EditItem" on the top of the ViewController*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }

//MARK: - Table View Data Source
    /*This is the method to generate rows inside the table view.*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    /*This is the method to generate rows fo the variables above.*/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)//This changes the text inside the cell generated.
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    //MARK: - Table View Delegate
    /*This method is to activate or di-activate the checkmark on a selected row.*/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveChecklistItems()
    }
    /*This method lets you delete a row when you slide the item to the left.*/
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    /*MARK: - Add Item ViewController Delegates
    //This method is for the "Cancel" button on the Navigation Control. When you press it, it returns you back to "Checklist" View Controller.*/
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    /*This method allows you to create a new item and added it to the list of the Checklist View Controller.*/
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    /*This method allows you to edit an existing item on the Checklist View Controller.*/
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistItem){
        if let index = items.firstIndex(of: item)
        {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
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
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        //This section of the code takes any errors that may occur and writes them to the Debug screen.
        do {
            let data = try encoder.encode(items)
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
                items = try decoder.decode(
                    [ChecklistItem].self,from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
