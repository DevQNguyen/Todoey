//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Quang  Nguyen on 1/25/19.
//  Copyright © 2019 Quang  Nguyen. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //Variable referencing an array of Category objects
    var categoryArray = [Category]()
    
    //Constant to reference persistent container object in AppDelegate.swift
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }

///////////////////////////////////////////
    
    //MARK: - TableView Datasource Methods
    
    //TODO: Determine number of rows in section

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    //TODO: Populate cell in specified row in indexpath
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Resue a cell that's out of the screen view
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //Populate cell textLabel with name from categoryArray
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }


///////////////////////////////////////////
    
    //MARK - TableView Delegate Methods
    
    
    
    
//////////////////////////////////////////
    
    //MARK: - FUnctionality: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Declare reference to instance of textField object
        var textField = UITextField()
        
        //Declare an alert popup
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        //Declare an action reference to the alert popup
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //Declare instance of Category object point to persistentContainer.viewContext
            let newCategory = Category(context: self.context)
            
            //Assign newCategory to user input from textField
            newCategory.name = textField.text!
            
            //When user click action popup append input to array
            self.categoryArray.append(newCategory)
            
            
            //Encode to persistent container
            self.saveCategories()
            
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
    
    //Save Context
    func saveCategories() {
        do  {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    
    //Load categories into SQlite database
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
                
        tableView.reloadData()
        
    }
        
    
    
    
   
    
    
}
