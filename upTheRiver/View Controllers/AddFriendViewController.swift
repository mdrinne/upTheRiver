//
//  AddFriendViewController.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 5/28/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var addFriendsTableView: UITableView!
    
    @IBOutlet weak var addFriendSearchBar: UISearchBar!
    
    @IBOutlet weak var addFriendsLabel: UILabel!
        
    var addFriendArray = [User]()
    var currentAddFriendArray = [User]()
    
    var currentUserFriends = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        queryUsers()
        setUpSearchBar()
    }
    
    private func setUpElements() {
        
        Utilities.styleLabelPrimary(label: addFriendsLabel)
        Utilities.styleSearchBar(searchBar: addFriendSearchBar)
        
    }
    
    private func queryUsers() {
        let db = Firestore.firestore()

        db.collection("users").getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error querying user documents: \(error!.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    if Auth.auth().currentUser?.uid != (document.get("uid") as! String) {
                        self.addFriendArray.append(User(fullName: document.get("fullName") as! String, username: document.get("username") as! String,uid: document.get("uid") as! String))
                        self.addFriendsTableView.reloadData()
                    }
                }
//                self.addFriendsTableView.reloadData()
            }
        }
    }
    
    private func setUpSearchBar() {
        let nib = UINib(nibName: "AddFriendTableViewCell", bundle: nil)
        addFriendsTableView.register(nib, forCellReuseIdentifier: "AddFriendTableViewCell")
        addFriendSearchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAddFriendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendTableViewCell", for: indexPath) as? AddFriendTableViewCell else {
            return UITableViewCell()
        }
        cell.addFriendFullNameLabel.text = currentAddFriendArray[indexPath.row].fullName
        cell.addFriendUsernameLabel.text = currentAddFriendArray[indexPath.row].username
        cell.cellDelegate = self
        cell.index = indexPath
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentAddFriendArray = [User]()
            addFriendsTableView.reloadData()
            return
        }
        currentAddFriendArray = addFriendArray.filter({ (addFriend) -> Bool in
            return addFriend.fullName.lowercased().contains(searchText.lowercased()) || addFriend.username.lowercased().contains(searchText.lowercased())
        })
        
        addFriendsTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
}

extension AddFriendViewController: TableViewAddFriend {
    func onClickAdd(index: Int) {
        let db = Firestore.firestore()
        
        let addUser = currentAddFriendArray[index]
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("friends").document(addUser.uid).setData(["fullName": addUser.fullName, "username": addUser.username, "uid": addUser.uid])
        
        addFriendArray.remove(at: addFriendArray.firstIndex(where: {$0 === addUser})!)
        currentAddFriendArray.remove(at: index)
        addFriendsTableView.reloadData()
    }
}
