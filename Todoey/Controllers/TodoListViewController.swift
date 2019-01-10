//
//  ViewController.swift
//  Todoey
//
//  Created by Quang  Nguyen on 1/5/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //Declare variable for array of Item objects
    var itemArray = [Item]()
    
    //Declare user default to persist key-value data across launches
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Declare an instance of Item object
        let newItem = Item()
        //Store string in newItem
        newItem.title = "Eat ice cream"
        //Append newItem to itemArray
        itemArray.append(newItem)
        
        
        //Append newItem2
        let newItem2 = Item()
        newItem2.title = "Buy Ferrari 458"
        itemArray.append(newItem2)
        
        //Append newItem3
        let newItem3 = Item()
        newItem3.title = "Buy 747 Jumbo Jet"
        itemArray.append(newItem3)
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
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
        
        let item = itemArray[indexPath.row]
        
        //Populate textLabel text with text from itemArray at current index
        cell.textLabel?.text = item.title
        
        //Ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
    
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
////////////////////////////////////////////////
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        //Toggle boolean condition of item, equivalent to longer if/else statement
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        //Remove checkmark if there is already one there, otherwise put one in
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
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
            
            //Declare instance of Item object
            let newItem = Item()
            
            //Set newItem to hold textFiel.text
            newItem.title = textField.text!
            
            //When user clicks, append object newItem
            self.itemArray.append(newItem)
            
            //Set the key and value for UserDefaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
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

