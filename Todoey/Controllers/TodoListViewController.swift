//
//  ViewController.swift
//  Todoey
//
//  Created by Quang  Nguyen on 1/5/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //Declare variable for array of Item objects as defined in Items.swift
    var itemArray = [Item]()
    
    //Declare reference for a dataFilePath to store data objects
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    //Declare user default to persist key-value data across launches
    //let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        print(dataFilePath)
        
        
        //Load data from PList as defined in dataFilePath
        loadItems()
        
        //Declare an instance of Item object
//        let newItem = Item()
//        //Store string in newItem
//        newItem.title = "Eat ice cream"
//        //Append newItem to itemArray
//        itemArray.append(newItem)
//
//
//        //Append newItem2
//        let newItem2 = Item()
//        newItem2.title = "Buy Ferrari 458"
//        itemArray.append(newItem2)
//
//        //Append newItem3
//        let newItem3 = Item()
//        newItem3.title = "Buy 747 Jumbo Jet"
//        itemArray.append(newItem3)
        
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }

    
 /////////////////////////////////////////////
    
    //MARK - Tableview Datasource Methods
    
    
    //TODO: Declare number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    //TODO: Populate cell at specified row of indexpath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        //Populate textLabel text with text from itemArray at current index
        cell.textLabel?.text = item.title
        
        //Ternary operator to determine whether to populate with checkmark or not
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
    
    //When row is tapped, execute specified code
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        //Toggle boolean condition of item, equivalent to longer if/else statement
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //Encode to PList at dataFilePath
        saveItems()
        
        //Reload content in tableView to include the above change
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
    //MARK - Create functionality for button in UIBar
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Declare reference to an instance of text field object
        var textField = UITextField()
        
        //Declare an alert popup
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //Declare an action reference to the alert popup
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //Declare instance of Item object
            let newItem = Item()
            
            //Set newItem to reference user input from textFiel.text
            newItem.title = textField.text!
            
            //When user clicks, append object newItem
            self.itemArray.append(newItem)
            
            //Set the key and value for UserDefaults
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //Encode to PList
            self.saveItems()
            
            
            //Reload TableView data for new entry to show in todoItemCell
            self.tableView.reloadData()
            
        }
        //Add textfield to alert popup
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        //Add an action to alert popup
        alert.addAction(action)
        //Present alert viewController
        present(alert, animated: true, completion: nil)
        
    }
    
    //Encode user inputed items to PList at dataFilePath
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
    }
    
    
    //Decode Plist located at dataFilePath to itemArray
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                try itemArray = decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
        
    }
    
}

