//  ViewController.swift
//  ToDoList
//
//  Created by Leon on 2021/12/9.
//  This App will be constructed in MVC design pattern, and reconstruct into MVVM design pattern

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : ToDoCategory?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportDarkMode()
        self.title = selectedCategory?.name
    }
    
    
    //    MARK: - TableView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
                
        if let item = todoItems?[indexPath.row] {

//        MARK: Support both after iOS 14 and earlier version
            
            if #available(iOS 14, *){
                var content = cell.defaultContentConfiguration()
                content.text = item.title
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = item.title
            }
            cell.accessoryType = item.done ? .checkmark : .none //Swift ternary operator
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    //    MARK: - CRUD: Update Selected Row Data
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status\(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    MARK: - Add New Item
    
    @IBAction func AddItemButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "新增工作", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        let action = UIAlertAction(title: "加入", style: .default) { [self] (action) in
            
            if let currentCategory = self.selectedCategory{
                
                do {
                    try realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        realm.add(newItem)
                    }
                } catch {
                    print("Saving Item Data Error: \(error)")
                }                
                tableView.reloadData()
            }
        }

        alert.addAction(action)
        alert.addAction(cancelAction)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "未命名的工作"
            textField = alertTextField
        }

        self.present(alert, animated: true, completion: nil)
    }
    
    //    MARK: - Data Manupulation
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}


// MARK: Search and Queue   
    extension TodoListViewController: UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                
                loadItems()
                
                DispatchQueue.main.async {
                    
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
