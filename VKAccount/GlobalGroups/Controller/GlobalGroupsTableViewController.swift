//
//  GlobalGroupsTableViewController.swift
//  VKAccount
//
//  Created by Заруцков Павел on 06.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

class GlobalGroupsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Properties
    
    var searchController:UISearchController!
    var groupsList: [Groups] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
    }

    // MARK: - Functions
    
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Введите запрос для поиска"
        tableView.tableHeaderView = searchController.searchBar
        searchController.obscuresBackgroundDuringPresentation = false // не скрывать таблицу под поиском (размытие), иначе не будет работать сегвей из поиска
        
        //автоматическое открытие клавиатуры для поиска
        searchController.isActive = true
        DispatchQueue.main.async {
          self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchGroupVK(searchText: String) {
        VKService().searchGroup(searchText: searchText) { [weak self] (complition) in
            DispatchQueue.main.async {
                self?.groupsList = complition
                self?.tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchGroupVK(searchText: searchText)
        }
    }
    
    // MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GlobalGroupCell", for: indexPath)  as! GlobalGroupsTableViewCell
        cell.globalGroupName.text = groupsList[indexPath.row].name
        if let imgUrl = URL(string: groupsList[indexPath.row].photo ?? "") {
            cell.globalGroupAvatar.load(url: imgUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
