//
//  RecipeSearchController.swift
//  RecipeSearch
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class RecipeSearchController: UIViewController {
    
    var searchQuery = ""{
        didSet{
            searchBarQuery()
        }
    }
    
    // TODO: we need a table view
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // TODO: we need a recipes array
    var recipes = [Recipe](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadData()
        searchBar.delegate = self
    }
    // TODO: on the recipes array we need a didSet() to update the table view
    // TODO: in cellForRow show the recipe's label
    // TODO: RecipSearchAPI.getRecipes("christmas cookies") {...}....accessing data to populate the recipes array e.g "christmas cookies"
    
    
    func searchBarQuery() {
        RecipeSearchAPI.getRecipe(for: "\(searchQuery)", completion: {[weak self] (result) in
        switch result {
        case .failure( let appError ):
            print("Error \(appError)")
        case .success( let recipes):
            self?.recipes = recipes.filter {$0.label.lowercased().contains(self!.searchQuery.lowercased())}
            }
    })
    }
    
    
    func loadData() {
        RecipeSearchAPI.getRecipe(for: "cookie", completion: {[weak self] (result) in
            switch result {
            case .failure( let appError ):
                print("Error \(appError)")
            case .success( let recipes):
                self?.recipes = recipes
            }
        })
    }
}


extension RecipeSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let selRecipe = recipes[indexPath.row]
        cell.textLabel?.text = selRecipe.label
        
        return cell
    }
    
    
}

extension RecipeSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchBarQuery()
            loadData()
            return
        }
        searchQuery = searchText
    }
}
