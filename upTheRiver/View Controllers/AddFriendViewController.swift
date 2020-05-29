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
    
    var addFriendArray = [AddFriend]()
    var currentAddFriendArray = [AddFriend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        queryUsers()
        setUpSearchBar()
    }
    
    private func queryUsers() {
        let db = Firestore.firestore()

        db.collection("users").getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error querying user documents: \(error!.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    if Auth.auth().currentUser?.uid != (document.get("uid") as! String) {
                        self.addFriendArray.append(AddFriend(fullName: document.get("fullName") as! String, username: document.get("username") as! String))
                    }
                }
                self.currentAddFriendArray = self.addFriendArray
                self.addFriendsTableView.reloadData()
            }
        }
    }
    
    private func setUpSearchBar() {
        addFriendSearchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAddFriendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Add Friend Table View Cell") as? AddFriendTableViewCell else {
            return UITableViewCell()
        }
        cell.userFullNameLabel.text = currentAddFriendArray[indexPath.row].fullName
        cell.userUsernameLabal.text = currentAddFriendArray[indexPath.row].username
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentAddFriendArray = addFriendArray
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


