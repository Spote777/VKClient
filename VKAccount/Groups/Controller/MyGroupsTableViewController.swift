//
//  MyGroupsTableViewController.swift
//  VKAccount
//
//  Created by Заруцков Павел on 06.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var notificationToken: NotificationToken?
    var groups: Results<Groups>!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGroupsFromRealm()
        subscribeToNotificationRealm()
        
        VKService().getGroups() { [weak self] (complition) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
     
    // MARK: - Realm
    
    var realm: Realm = {
        let configrealm = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: configrealm)
        return realm

    }()
    
    lazy var groupsFromRealm: Results<Groups> = { return realm.objects(Groups.self) }()
    
    func loadGroupsFromRealm() {
        do {
            let realm = try Realm()
            let groupsFromRealm = realm.objects(Groups.self)
            groups = groupsFromRealm
            guard groupsFromRealm.count != 0 else { return } // проверка, что в реалме что-то есть
        } catch {
            print(error)
        }
    }
    
    private func subscribeToNotificationRealm() {
        notificationToken = groupsFromRealm.observe { [weak self] (changes) in
            switch changes {
            case .initial:
                self?.loadGroupsFromRealm()
            case .update:
                self?.loadGroupsFromRealm()
            case let .error(error):
                print(error)
            }
        }
    }
    
    // MARK: - TableViewDataSource
    
    @IBAction func addGroup(segue: UIStoryboardSegue){
        if segue.identifier == "addGroup" {
            guard let globalGroupsController = segue.source as? GlobalGroupsTableViewController else {return}
            
            if let indexPath = globalGroupsController.tableView.indexPathForSelectedRow {
                let newGroup = globalGroupsController.groupsList[indexPath.row]
                guard groups.description.contains(newGroup.name) else { return }
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsTableViewCell
        cell.nameGroup.text = groups[indexPath.row].name
        if let imgUrl = URL(string: groups[indexPath.row].photo ?? "") {
            cell.avatarGroup.load(url: imgUrl)
        }
        return cell
    }
    
//    //удаляем группу
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            groups.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
}
