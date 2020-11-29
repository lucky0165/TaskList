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
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            
            var textField = UITextField()
            
            let categoryToEdit = self.categories[indexPath.row]
  
            let alert = UIAlertController(title: "Edit category", message: "", preferredStyle: .alert)
            
            alert.addTextField { (editTextField) in
                editTextField.placeholder = "New category name"
                textField = editTextField
            }
            
            let save = UIAlertAction(title: "Save", style: .default) { (action) in
                categoryToEdit.name = textField.text
                self.saveCategories()
                self.loadCategories()
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(save)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let categoryToRemove = self.categories[indexPath.row]
            self.context.delete(categoryToRemove)
            self.categories.remove(at: indexPath.row)
            
            self.saveCategories()
            self.loadCategories()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

