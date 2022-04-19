//
//  SwipeTableViewController.swift
//  ToDoList
//
//  Created by leon on 2022/3/21.
//

import UIKit

class SwipeTableViewController: UITableViewController {
    let backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 229/255, alpha: 1)
    let barButtonItemColor = UIColor.black
    
    func supportDarkMode(){
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    override func viewDidLoad() {


        tableView.rowHeight = 80.0
        
        navigationItem.rightBarButtonItem?.tintColor = barButtonItemColor
        
        navigationItem.leftBarButtonItem?.tintColor = barButtonItemColor

        view.backgroundColor = backgroundColor
        super.viewDidLoad()
    }
    
//    TableView Delegate Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = view.backgroundColor
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            print("Delete cell")
            
            updateModel(at: indexPath)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func updateModel(at indexPath: IndexPath) {
//        Set a port for updating data from Model
    }

}
