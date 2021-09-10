//
//  AllListsViewController.swift
//  Checklist
//
//  Created by Josue Mendoza on 9/4/21.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    let cellIdentifier = "ChecklistCell"
    
    var dataModel: DataModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    //This method places the text of the list varibables.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //These constant variables places a subtitle under the main cell text field.
        let cell: UITableViewCell!
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
        } else { cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)}
        
        let checklist = dataModel.lists[indexPath.row]
        //This constant variable places the subtitle text under the Checklist Item.
        let count = checklist.countUncheckedItems()
        //This boolean determines how many items are checked/unchcecked inside the Checklist
        if checklist.items.count == 0 {
        cell.detailTextLabel!.text = "(No Items)"
        } else {
            cell.detailTextLabel!.text = count == 0 ?
            "All Done" : "\(count) Remaining"
        }
        
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        dataModel.indexOfSelectedChecklist = indexPath.row
        /*UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")*/
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    /*This method lets you delete a row when you slide the item to the left.*/
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    //This method allows you to Edit a selected row from the "Checklists" View Controller
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        let controller = storyboard!.instantiateViewController(identifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
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
    //MARK: - NAVIGATION CONTROLLER DELEGATES
        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
        {
            if viewController === self {
                dataModel.indexOfSelectedChecklist = -1
            }
        }
    
    //MARK: - List Detail View Controller Delegates
    
    //This method is for the "Cancel" button on the Navigation Control. When you press it, it returns you back to "Checklist" View Controller.*/
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    /*This method allows you to create a new item and added it to the list of the Checklist View Controller.*/
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
        
    }
    /*This method allows you to edit an existing item on the Checklist View Controller.*/
    func listDetailViewController(_ controller: ListDetailViewController,didFinishEditing checklist: Checklist){
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }


}
