//
//  ViewController.swift
//  Checklists
//
//  Created by Josue Mendoza on 8/27/21.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    /*This is the variable that calls for the variables inside the "ChecklistItem.swift" file in the bundle.*/
    var checklist: Checklist!
    
    /*This is the standard method that Xcode inserts when you start a new viewcontroller*/
    override func viewDidLoad() {
        super.viewDidLoad()
        //This syntex is so that the title of the navigation contoller has a standard style text.
        navigationItem.largeTitleDisplayMode = .never
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
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

//MARK: - Table View Data Source
    /*This is the method to generate rows inside the table view.*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    /*This is the method to generate rows fo the variables above.*/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)//This changes the text inside the cell generated.
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    //MARK: - Table View Delegate
    /*This method is to activate or di-activate the checkmark on a selected row.*/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    /*This method lets you delete a row when you slide the item to the left.*/
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        
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
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        
        
    }
    /*This method allows you to edit an existing item on the Checklist View Controller.*/
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistItem){
        if let index = checklist.items.firstIndex(of: item)
        {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
        
    }

}
