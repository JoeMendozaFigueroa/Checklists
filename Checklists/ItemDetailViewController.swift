//
//  itemDetailViewController.swift
//  Checklists
//
//  Created by Josue Mendoza on 8/27/21.
//

import UIKit

//This protocol method group is used in "Checklist View Controller" to Cancel, Add, & Edit into the cells.
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    
    func itemDetailViewController(_ controller:ItemDetailViewController, didFinishAdding item: ChecklistItem)
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
    }

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    //The below various variables and methods, are the objects inside the Item View Controller, as well the Title screen.

    @IBOutlet var textField: UITextField!
    
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //This is the syntext for the title of the "Item Detail View Controller", so that it is not a title text 
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //MARK: - Actions
    //This method is for the "Cancel" object, which takes you back to the "Checklist View Controller".
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    //This method is for the "Done" object, which takes you back to the "Checklist View Controller" once your done editing or adding a text cell. This button is "Deactivated" when there's no text in the text field.
    @IBAction func done() {
        if let item = itemToEdit {
        item.text = textField.text!
        delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    //MARK: - Table View Delegates
    //This is the method which generates a table view.
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK: - Text Field Delegates
    //This method lets you edit the current Text on the list that a user has selected.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    //This method determines wether the "Done" button on the "Add Item" View Controller is active when there's text in the Text Field object.
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
