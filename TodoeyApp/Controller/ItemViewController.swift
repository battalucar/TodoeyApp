//
//  ViewController.swift
//  TodoeyApp
//
//  Created by Battal Uçar on 30.10.2022.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        searchBar.delegate = self
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }
    
    // MARK: - Tableview data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.text = item.title
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = item.title
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.text = "No items added yet"
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = "No items added yet"
            }
        }
        
        return cell
    }
    
    // MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status. \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add new Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date.now
                        currentCategory.items.append(newItem)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error saving item. \(error)")
                }
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data manipulation
    
    func save(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving item. \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
}

// MARK: - Search bar

extension ItemViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadItems()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        UIView.animate(withDuration: 0.1) {
            searchBar.layoutIfNeeded()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        UIView.animate(withDuration: 0.1) {
            searchBar.layoutIfNeeded()
        }
    }
}

