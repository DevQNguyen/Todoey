//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Quang  Nguyen on 1/25/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    // Initialize an instance of realm with forced uwrap
    let realm = try! Realm()
    
    // Reference to Result type container with Category (optional) objects
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }

///////////////////////////////////////////
    
    //MARK: - TableView Datasource Methods
    
    //TODO: Determine number of rows in section

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Use 'Nil Coalesing Operator', if categories not nil use count, else use 1
        return categories?.count ?? 1
        
    }
    
    //TODO: Populate cell in specified row in indexpath
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Resue a cell that's out of the screen view
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //Populate cell textLabel with name from categeries? if not nil, if nil use provided text
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
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
    
    // Add/CREATE data to Realm database
    func save(category: Category) {
        do  {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
    }
    
    
    //Load/READ categories into SQlite database
    func loadCategories() {
        
        // Pullout all items inside realm constainer of Category object
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
        
    
    
    
   
    
    
}
