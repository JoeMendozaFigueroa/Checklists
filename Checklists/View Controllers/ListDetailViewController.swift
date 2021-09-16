//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Josue Mendoza on 9/6/21.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
    }

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    @IBOutlet var iconImage: UIImageView!
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    var iconName = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //This bool is wether a user wants to edit an item or not and it's to identify all the items on the screen (labels, switch, icons, etc.)
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
        }
        iconImage.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //MARK: - Actions
    //This method is for the "Cancel" object, which takes you back to the "Checklist View Controller".
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    //This method is for the "Done" object, which takes you back to the "Checklist View Controller" once your done editing or adding a text cell. This button is "Deactivated" when there's no text in the text field.
    @IBAction func done() {
        if let checklist = checklistToEdit {
        checklist.name = textField.text!
        checklist.iconName = iconName
        delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    //MARK: - Table View Delegates
    //This is the method which generates a table view.
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath: nil
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
    
    //MARK: - ICON PICKER VIEW CONTROLLER DELEGATE
    //This is the segue to pick an icon for an item on the list.
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
    {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - NAVIGATION
    //This method is for when you select an Icon, it brings you back to the previous screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as!
        IconPickerViewController
            controller.delegate = self
        }
    }
}
