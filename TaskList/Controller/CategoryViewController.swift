//
//  ViewController.swift
//  TaskList
//
//  Created by Łukasz Rajczewski on 29/11/2020.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    // MARK: - Saving Data
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Retrieving Data
    func loadCategories(request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories: \(error)")
        }
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category name"
            textField = alertTextField
        }
        
        
        let save = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField.text {
                if text.count > 1 {
                    let newCategory = Category(context: self.context)
                    newCategory.name = text
                    
                    self.categories.append(newCategory)
                    
                    self.saveCategories()
                    
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    
    }
    
    // MARK: - UITableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

