//
//  ViewController.swift
//  Todoey
//
//  Created by Quang  Nguyen on 1/5/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {
    
    // Declare variable to reference Results container of Item objects
    var todoItems: Results<Item>?
    
    // Declare new instance of realm
    let realm = try! Realm()
    
    // Passed in from CategoryViewController in prepare(for segue)
    var selectedCategory: Category? {
        //Once Category gets a value, load items into array
        didSet{
            loadItems()
        }
    }
    
    //Declare reference for a dataFilePath to store data objects
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    
    //Declare user default to persist key-value data across launches
    //let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        
    }

    
 /////////////////////////////////////////////
    
    //MARK - Tableview Datasource Methods
    
    
    //TODO: Declare number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the count of not nil, otherwise return 1
        return todoItems?.count ?? 1
        
    }
    
    //TODO: Populate cell at specified row of indexpath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            //Populate textLabel text with text from itemArray at current index
            cell.textLabel?.text = item.name
            
            //Ternary operator to determine whether to populate with checkmark or not
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No Items Added"
        }

        return cell
        
    }
    
////////////////////////////////////////////////
    
    //MARK - Tableview Delegate Methods
    
    //When row is tapped, execute specified code
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Updating done status of item
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // Toggle boolean value
                    item.done = !item.done
                }
            } catch {
                print("Error updating item done status, \(error)")
            }
        }
        
        //Reload content in tableView to include the above change
        tableView.reloadData()
        
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
            
            // If selectedCategory is not nil, add newItem
            if let currentCategory = self.selectedCategory {
                
                // Write to realm container
                do {
                    try self.realm.write {
                        
                        // Initialize new Item object
                        let newItem = Item()
                        // Set .name for newItem from textField input
                        newItem.name = textField.text!
                        // Append newItem to currentCategory items list
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    print("Error adding new item, \(error)")
                }
                
            }
            
            //Reload TableView data for new entry to show in todoItemCell
            self.tableView.reloadData()
            
        }
        //Add textfield to alert popup
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        //Add an action to alert popup
        alert.addAction(action)
        //Present alert viewController
        present(alert, animated: true, completion: nil)
        
    }
    
    //Encode user inputed items to PList at dataFilePath
//    func saveItems() {
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context, \(error)")
//        }
//
//    }
    
    
    // Load items from realm database
    func loadItems() {
        
        // Get all items from selectedCategory and sort accordingly
        todoItems = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
    }
    
    
}


///////////////////////////////////////////

//MARK: - Search Bar Methods

//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        //Declare a constant reference to a fetch request object from a persistent storage
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        //Use NSPredicate to filter search term. 'cd', after CONTAINS excludes case and diacritics
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //Create a sort descriptor
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        //Call method that loads request items into itemArray
//        loadItems(with: request, predicate: predicate)
//
//    }
//
//    //Method to take user back to tableView when searchbar text has changed
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        //If there is no text in search bar
//        if searchBar.text?.count == 0 {
//            //1. load fetched items into itemArray
//            loadItems()
//            //2. Prioritize execution of code inside curly bracket
//            DispatchQueue.main.async {
//                //3. turn off searchbar as first responder
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//}
//
