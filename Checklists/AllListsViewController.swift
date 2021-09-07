//
//  AllListsViewController.swift
//  Checklist
//
//  Created by Josue Mendoza on 9/4/21.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {

    let cellIdentifier = "ChecklistCell"
    
    var lists = [Checklist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: cellIdentifier)
        
        loadChecklists()
        
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        
        list = Checklist(name: "Groceries")
        lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist(name: "To Do")
        lists.append(list)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        navigationController?.navigationBar.prefersLargeTitles = true

        //MARK: - PLACEHOLDER ITEM DATA
        for list in lists {
        let item = ChecklistItem()
        item.text = "Item for \(list.name)"
        list.items.append(item)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    //This method places the text of the list varibables.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    /*This method lets you delete a row when you slide the item to the left.*/
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    //This method allows you to Edit a selected row from the "Checklists" View Controller
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        let controller = storyboard!.instantiateViewController(identifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Navigation
    //This method changes the title of the "Checklist" View Controller, to the name the user selects in the Checklists View Controller
    override func prepare(
        for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as!
            ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    //MARK: - List Detail View Controller Delegates
    
    //This method is for the "Cancel" button on the Navigation Control. When you press it, it returns you back to "Checklist" View Controller.*/
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    /*This method allows you to create a new item and added it to the list of the Checklist View Controller.*/
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = lists.count
        lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        
    }
    /*This method allows you to edit an existing item on the Checklist View Controller.*/
    func listDetailViewController(_ controller: ListDetailViewController,didFinishEditing checklist: Checklist){
        if let index = lists.firstIndex(of: checklist)
        {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
        navigationController?.popViewController(animated: true)
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
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
