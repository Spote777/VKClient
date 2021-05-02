//
//  MyFriendsTableViewController.swift
//  VKAccount
//
//  Created by Заруцков Павел on 06.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit
import RealmSwift

class MyFriendsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var notificationToken: NotificationToken?
    var friendsList: Results<Friends>!
    var filteredUsers = Friends()
    var namesListFixed: [String] = []
    var namesListModifed: [String] = []
    var letersOfNames: [String] = []
    var photoService: PhotoService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoService = PhotoService(container: tableView)
        loadFriendsFromRealm()
        subscribeToNotificationRealm()
        
        VKService().getFriend() { [weak self] (complition) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        
    }
    
    // MARK: - Realm
    
    var realm: Realm = {
        let configrealm = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: configrealm)
        return realm
    }()
    
    lazy var friendsFromRealm: Results<Friends> = { return realm.objects(Friends.self) }()
    
    
    func loadFriendsFromRealm() {
        do {
            let realm = try Realm()
            let friendsFromRealm = realm.objects(Friends.self)
            friendsList = friendsFromRealm
            guard friendsList.count != 0 else { return } // проверка, что в реалме что-то есть
            makeNamesList()
            sortCharacterOfNamesAlphabet()
        } catch {
            print(error)
        }
    }
    
    private func subscribeToNotificationRealm() {
        notificationToken = friendsFromRealm.observe { [weak self] (changes) in
            switch changes {
            case .initial:
                self?.loadFriendsFromRealm()
            case .update:
                self?.loadFriendsFromRealm()
            case let .error(error):
                print(error)
            }
        }
    }
    
    // MARK: - functions
    // создание массива из имен пользователей
    func makeNamesList() {
        namesListFixed.removeAll()
        for item in 0...(friendsList.count - 1){
            namesListFixed.append(friendsList[item].fullName)
        }
        namesListModifed = namesListFixed
    }
    
    func sortCharacterOfNamesAlphabet() {
        var letersSet = Set<Character>()
        letersOfNames = [] // обнуляем массив на случай повторного использования
        // создание сета из первых букв имени, чтобы не было повторов
        for name in namesListModifed {
            letersSet.insert(name[name.startIndex])
        }
        // заполнение массива строк из букв имен
        for leter in letersSet.sorted() {
            letersOfNames.append(String(leter))
        }
    }
    
    func getNameFriendForCell(_ indexPath: IndexPath) -> String {
        var namesRows = [String]()
        for name in namesListModifed.sorted() {
            if letersOfNames[indexPath.section].contains(name.first!) {
                namesRows.append(name)
            }
        }
        return namesRows[indexPath.row]
    }
    
    func getAvatarFriendForCell(_ indexPath: IndexPath) -> URL? {
        for friend in friendsList {
            let namesRows = getNameFriendForCell(indexPath)
            if friend.fullName.contains(namesRows) {
                return URL(string: friend.photo ?? "")
            }
        }
        return nil
    }
    
    func getIDFriend(_ indexPath: IndexPath) -> String {
        var ownerIDs = 0
        for friend in friendsList {
            let namesRows = getNameFriendForCell(indexPath)
            if friend.fullName.contains(namesRows) {
                ownerIDs = friend.id
                return friend.photo ?? ""
            }
        }
        return String(ownerIDs)
    }
    
    // MARK: - searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        namesListModifed = searchText.isEmpty ? namesListFixed : namesListFixed.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        sortCharacterOfNamesAlphabet()
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = nil
        makeNamesList() // возвращаем массив имен
        sortCharacterOfNamesAlphabet()  // создаем заново массив заглавных букв для хедера
        tableView.reloadData() //обновить таблицу
        searchBar.resignFirstResponder() // скрыть клавиатуру
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfRows = 0
        // сравниваем массив букв и заглавные буквы каждого имени, выводим количество ячеек в соотвествии именам на отдельную букву
        for name in namesListModifed {
            if letersOfNames[section].contains(name.first!) {
                countOfRows += 1
            }
        }
        return countOfRows
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return letersOfNames.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return letersOfNames[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 35))
        view.backgroundColor = .init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 8, width:15, height:15)
        label.text = letersOfNames[section]
        label.textColor = UIColor.black
        view.addSubview(label)
        self.view.addSubview(view)
        return view
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letersOfNames
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! MyFriendsTableViewCell
        
        cell.nameFriend.text = getNameFriendForCell(indexPath)
        if let imageUrl = getAvatarFriendForCell(indexPath) {
            cell.photoFriend.load(url: imageUrl)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showListUsersPhoto" {
            let friendPhotoView = segue.destination as? FriendPhotoCollectionViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let friend = friendsList[indexPath.row]
                friendPhotoView?.titleItem = getNameFriendForCell(indexPath)
                friendPhotoView?.ownerId = friend.id
                friendPhotoView?.fetchRequestPhotosUser(for: friend.id)
            }
        }
    }
}

//    //удаляем друга
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            friendsList.remove(at: indexPath.row)
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
