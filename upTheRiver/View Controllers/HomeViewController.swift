//
//  HomeViewController.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 5/28/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var joinTableButton: UIButton!
    
    @IBOutlet weak var createTableButton: UIButton!
    
    @IBOutlet weak var upTheRiverLabel: UILabel!
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    var friendsArray = [User]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
        queryFriends()
        setupFriendsTable()
    }
    
    func setupElements() {
        
        Utilities.styleFilledButton(createTableButton)
        Utilities.styleFilledButton(joinTableButton)
        Utilities.styleHollowButton(addFriendButton)
        Utilities.styleLabelPrimary(label: upTheRiverLabel)
        friendsTableView.layer.cornerRadius = 10
    }
    
    func queryFriends() {
        let db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("friends").getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error querying users friend documents: \(error!.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    self.friendsArray.append(User(fullName: document.get("fullName") as! String, username: document.get("username") as! String, uid: document.get("uid") as! String))
                    self.friendsTableView.reloadData()
                }
            }
        }
    }
    
    func setupFriendsTable() {
        let nib = UINib(nibName: "FriendTableViewCell", bundle: nil)
        friendsTableView.register(nib, forCellReuseIdentifier: "FriendTableViewCell")
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
    }
    
    /* Table Functions */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        cell.friendFullNameLabel.text = friendsArray[indexPath.row].fullName
        cell.friendUsernameLabel.text = friendsArray[indexPath.row].username
        
        return cell
    }
    
    /* *************** */
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? ViewController
            
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        } catch let err {
            print(err)
        }
    }
    
    @IBAction func addFriendTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "addFriend", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! AddFriendViewController
//        vc.currentUserFriends = self.friendsArray
//    }
    
    @IBAction func createTableTapped(_ sender: Any) {
        let createTablePopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CreateTablePopUpViewController") as! CreateTablePopUpViewController
        self.addChild(createTablePopUpVC)
        createTablePopUpVC.view.frame = self.view.frame
//        self.view.addSubview(createTablePopUpVC.view)
        UIView.transition(with: self.view, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.view.addSubview(createTablePopUpVC.view)
        }, completion: nil)
        createTablePopUpVC.didMove(toParent: self)
    }
    
}
