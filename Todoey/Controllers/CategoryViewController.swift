//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Quang  Nguyen on 1/25/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    // Initialize an instance of realm with forced uwrap
    let realm = try! Realm()
    
    // Reference to Result type container with Category (optional) objects
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        // Remove tableview row separators
        tableView.separatorStyle = .none
        
    }

///////////////////////////////////////////
    
    //MARK: - TableView Datasource Methods
    
    //TODO: Determine number of rows in section

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Use 'Nil Coalesing Operator', if categories not nil use count, else use 1
        return categories?.count ?? 1
        
    }
    
    
    //TODO: Populate cell in specified row at indexpath
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Tap into superclass(SwipeTableViewController) to load cell properties at current indexPath
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Grab category object at specified row if it exists
        guard let category = categories?[indexPath.row] else {fatalError("Category Does Not Exist!")}
        
        // Get UIColor from Category object
        guard let categoryColor = UIColor(hexString: category.color) else {fatalError("Color Does Not Exist!")}
        
        //Populate cell textLabel with name from current categeries? if not nil, if nil use provided text
        cell.textLabel?.text = category.name
        
        // Set Category text to be contrasting color with background
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        // Set random color for tableview row color
        cell.backgroundColor = categoryColor
    
        return cell
    }


///////////////////////////////////////////
    
    //MARK - TableView Delegate Methods
    // Perform segue when a row is tapped/selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    // Passing selected category over to TodoListViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
 
        }
    }
    
//////////////////////////////////////////
    
    //MARK: - FUnctionality: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Declare reference to instance of textField object
        var textField = UITextField()
        
        //Declare an alert popup
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        //Declare an action reference to the alert popup
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // Initialize instance of Category object from Category class
            let newCategory = Category()
            
            //Assign newCategory to user input from textField
            newCategory.name = textField.text!
            
            //Assign random color to newCategory
            newCategory.color = UIColor.randomFlat.hexValue()
            
            //Encode to persistent container
            self.save(category: newCategory)
            
            //Reload data for new entry to show in cell
            self.tableView.reloadData()
            
        }
        
        //Add textField to alert popup
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        //Add an action to alert popup
        alert.addAction(action)
        //Present alert viewController
        present(alert, animated: true, completion: nil)
        
    }
    
//////////////////////////////////////////
    
    //MARK: - Data Manipulation Methods
    
    // Add/CREATE new category to Realm database
    func save(category: Category) {
        do  {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
    }
    
    
    //MARK - Load/READ categories from Realm database to global variable
    func loadCategories() {
        
        // Pullout all items inside realm constainer of Category object
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //MARK - Delete selected category
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }

}

