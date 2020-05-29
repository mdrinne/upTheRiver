//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var joinTableButton: UIButton!
    
    @IBOutlet weak var createTableButton: UIButton!
    
    @IBOutlet weak var upTheRiverLabel: UILabel!
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    @IBOutlet weak var addFriendButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
    }
    
    func setupElements() {
        
        Utilities.styleFilledButton(createTableButton)
        Utilities.styleFilledButton(joinTableButton)
        Utilities.styleHollowButton(addFriendButton)
        Utilities.styleLabelPrimary(label: upTheRiverLabel)
    }
    
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
    
}
