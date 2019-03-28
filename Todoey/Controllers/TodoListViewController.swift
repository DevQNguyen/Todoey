//
//  ViewController.swift
//  Todoey
//
//  Created by Quang  Nguyen on 1/5/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    // Declare variable to reference Results container of Item objects
    var todoItems: Results<Item>?
    
    // Declare new instance of realm
    let realm = try! Realm()
    
    // IBOutlet view
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // Passed in from CategoryViewController in prepare(for segue)
    var selectedCategory: Category? {
        //Once Category gets a value, load items into todoItems' collection of Item objects
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
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        
    }

    // Right before view loads, set navBar color to be same as selectedCategory
    override func viewWillAppear(_ animated: Bool) {
        
        // set navBar title
        title = selectedCategory!.name
        
        guard let colorHex = selectedCategory?.color else {fatalError("Selected Category Hex Color Not Found")}
        
        updateNavBar(withHexCode: colorHex)

    }
    
    // Reset navBar color back to original when 'back' button is clicked
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")

    }
    
    
    //MARK: - Update navBar Color
    func updateNavBar(withHexCode colorHexCode: String){
        
        //Grab navBar and assign to variable
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller Does Not Exist.")}
        
        // Set UIColor using passed in argument with string of hex color
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError("UI Color Not Available")}
        
        // Apply color to navBar background
        navBar.barTintColor = navBarColor
        // Apply contrasting color to navBar button & items
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        // Apply constrast color to large text
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        // Apply searcBar background color
        searchBar.barTintColor = navBarColor
        
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
        
        // Grab dequeued cell from superclass tableview
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            //Populate textLabel text with text from todoItems array at current row
            cell.textLabel?.text = item.name
            
            // selectedCategory can be forced unwrap because todoItem is not nil
            let persistedRowColor = UIColor(hexString: selectedCategory!.color)
            // Optional binding
            if let color = persistedRowColor?.darken(byPercentage:
                (CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                // Set background color for row
                cell.backgroundColor = color
                // Use ChameleonFramework to automatically set text color contrast
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                // Set checkmark color to contrast with background
                cell.tintColor = ContrastColorOf(color, returnFlat: true)
            }
            
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
                    
                    // ** Instead of toggling, we can use Realm to delete the selected row **
                    //realm.delete(item)
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
                        // Get timestamp for newItem
                        newItem.dateCreated = Date()
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
        
    
    //MARK - Load items from realm database
    func loadItems() {
        
        // Get all items from selectedCategory and sort accordingly
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK - Delete selected item
    override func updateModel(at indexPath: IndexPath){
        //Update data model
        if let itemForDeletion = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
}


///////////////////////////////////////////

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    //Method to take user back to tableView when searchbar text has changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //If there is no text in search bar
        if searchBar.text?.count == 0 {
            //1. load items
            loadItems()
            //2. Prioritize execution of code inside curly bracket
            DispatchQueue.main.async {
                //3. turn off searchbar as first responder
                searchBar.resignFirstResponder()
            }
        }
    }

}

