//
//  CategoriesTableViewController.swift
//  Todoey
//
//  Created by Livo App on 05/07/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    //MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category?.name ?? "Sem categorias cadastradas"
        
        return cell
    }
    
    //MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - Add new Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var txtFld = UITextField()
        
        let alert = UIAlertController(title: "Inserir Nova Categoria", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
                        
            let newCategory = Category()
            newCategory.name = txtFld.text!
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { alertTxtFld in
            alertTxtFld.placeholder = "Criar Nova Categoria"
            txtFld = alertTxtFld
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func save(category: Category) {
                
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("error de salvamento \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategories(){

        categories =  realm.objects(Category.self)
        tableView.reloadData()

    }
}
