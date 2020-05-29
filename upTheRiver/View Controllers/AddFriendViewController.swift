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

class AddFriendViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var addFriendsTableView: UITableView!
    
    @IBOutlet weak var UserSearchBar: UISearchBar!
    
    var addFriendArray = [AddFriend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        queryUsers()
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
                self.addFriendsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addFriendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Add Friend Table View Cell") as? AddFriendTableViewCell else {
            return UITableViewCell()
        }
        cell.userFullNameLabel.text = addFriendArray[indexPath.row].fullName
        cell.userUsernameLabal.text = addFriendArray[indexPath.row].username
        
        return cell
    }

}


