//
//  ViewController.swift
//  Todoey
//
//  Created by Quang  Nguyen on 1/5/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Buy nachos", "Buy noodles", "Buy tiramisu cake"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    
 /////////////////////////////////////////////
    
    //MARK - Tableview Datasource Methods
    
    
    //TODO: Declare number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    //TODO: Declare cell for row at indexpath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        //Populate textLabel text with text from itemArray at current index
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
////////////////////////////////////////////////
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //Remove checkmark if there is already one there, otherwise put one in
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //Deselect highlighting of row after tap action
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
//////////////////////////////////////////////////
    //MARK - Add New Items Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Declare local scope textfield object variable
        var textField = UITextField()
        
        //Create a alert popup
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        //Create a alert action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //When user clicks, append text in textfield to array
            self.itemArray.append(textField.text!)
            //Reload TableView data for new entry to show in todoItemCell
            self.tableView.reloadData()
            
        }
        //Add textfield to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        //Add action
        alert.addAction(action)
        //Present alert viewController
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

