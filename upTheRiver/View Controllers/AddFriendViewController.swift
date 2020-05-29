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

class AddFriendViewController: UIViewController {
    
    @IBOutlet weak var addFriendsTableView: UITableView!
    
    @IBOutlet weak var UserSearchBar: UISearchBar!
    
    var userArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func queryUsers() {
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error querying user documents: \(error!.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    if Auth.auth().currentUser?.uid != (document.get("uid") as! String) {
                        self.userArray.append(User(fullName: document.get("fullName") as! String, username: document.get("username") as! String))
                    }
                }
            }
        }
    }

}

class User {
    
    let fullName: String
    let username: String
    
    init(fullName: String, username: String) {
        self.fullName = fullName
        self.username = username
    }
}
