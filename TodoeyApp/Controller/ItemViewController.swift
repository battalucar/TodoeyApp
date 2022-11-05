//
//  ViewController.swift
//  TodoeyApp
//
//  Created by Battal Uçar on 30.10.2022.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }
    
    // MARK: - Tableview data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = item.title
        }

        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Update data from CoreData
        // itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        // Remove data from CoreData
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add new Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context. \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context. \(error)")
        }
    }
    
}

