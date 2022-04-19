//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by leon on 2022/3/6.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
            
    var categories: Results<ToDoCategory>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Next Right Thing"
                
        loadCategories()
        supportDarkMode()
    }
    

    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //    MARK: TableView Datasoruce Methods    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories?[indexPath.row].name ?? "Add New Category"
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if #available(iOS 14, *){
            var content = cell.defaultContentConfiguration()
            content.text = category
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = categories?[indexPath.row].name ?? "Add new Catagory"
        }
        
        return cell
    }
    
    
    //    MARK: Add New Categories
    @IBAction func AddCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "新增清單", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "加入", style: .default) { (Action) in
            let newCategory = ToDoCategory()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        alert.addTextField { alertTextField in
            
            alertTextField.placeholder = "未命名的清單"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}

//    MARK: Data Manipulation

extension CategoryViewController {
    
//    Load Categories
    
    func loadCategories(){
        categories = realm.objects(ToDoCategory.self)
        tableView.reloadData()
    }
        
//    Save Categories
    
    func save(category: ToDoCategory){
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Saving Category Data Error: \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}
