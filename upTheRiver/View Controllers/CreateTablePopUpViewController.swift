//
//  CreateTablePopUpViewController.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 6/1/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit
import SwiftSocket
import FirebaseAuth
import Firebase

class CreateTablePopUpViewController: UIViewController {

    @IBOutlet weak var tableNameTextField: UITextField!
    
    @IBOutlet weak var userNicknameTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var popUpView: UIView!
    
    var SERVER = "192.168.1.249"
    
    var currentUser: User!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        db = Firestore.firestore()
        getCurrentUser()
    }

    func setUpElements() {
        
        Utilities.styleTextField(tableNameTextField)
        Utilities.styleTextField(userNicknameTextField)
        Utilities.styleHollowButton(cancelButton)
        Utilities.styleFilledButton(createButton)
        popUpView.layer.cornerRadius = 20
    }
    
    func getCurrentUser() {
        db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error querying user documents: \(error!.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    self.currentUser = User(fullName: document.get("fullName") as! String, username: document.get("username") as! String, uid: document.get("uid") as! String, inGame: document.get("inGame") as! Int)
                }
                
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != popUpView {
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func createTapped(_ sender: Any) {
        let tableName = tableNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let client = TCPClient(address: SERVER, port: 25000)
        
        switch client.connect(timeout: 10) {
        case .success:
            print("connection success")
            let createTableMessage = "createTable;\(tableName);\(Auth.auth().currentUser!.uid)"
            switch client.send(string: createTableMessage) {
            case .success:
                print("sent message to server successfully")
                guard let data = client.read(64, timeout: 10) else {
                    print("read from server failed")
                    client.close()
                    return
                }
                if let response = String(bytes: data, encoding: .utf8) {
                    let responseArray = response.split(separator: ";")
                    
                    switch responseArray[0] {
                    case "newTablePort":
                        print(responseArray[1])
                        client.close()
                        let port = Int(String(responseArray[1]))!
                    db.collection("tables").document(String(port)).setData(["name":tableName, "port":port])
                        transitionToTable(port: port)
                        
                    case "noOpenPort":
                        // Add toast here!!!!!!!!!!!!!!!!!!!!!!!!
                        print("no open ports at this time")
                        client.close()
                        
                    default:
                        print(response)
                        client.close()
                    }
                }
            case .failure(_):
                print("failed to send message to server")
                client.close()
            }
            
        case .failure(_):
            print("connection failed")
        }
        
    }
    
    func transitionToTable(port: Int) {
        sleep(2)
        let clientConnection = TCPClient(address: SERVER, port: Int32(port))
        switch clientConnection.connect(timeout: 10) {
        case .success:
            print("[CONNECTED TO TABLE]")
            let tableViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tableViewController) as? TableViewController
            tableViewController?.clientConnection = clientConnection
            tableViewController?.connectionOpen = 1
            tableViewController?.owner = 1
            tableViewController?.port = port
            tableViewController?.currentUser = currentUser
            if userNicknameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                tableViewController?.nickname = currentUser.username
            } else {
                tableViewController?.nickname = userNicknameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            view.window?.rootViewController = tableViewController
            view.window?.makeKeyAndVisible()
        case .failure(let error):
            // ADD TOAST HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            print("[FAILED CONNECTION] failed to connect client to table")
            print(error)
        }
//            let tableViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tableViewController) as? TableViewController
//
//            tableViewController?.port = port
//            tableViewController?.currentUser = currentUser
//            if userNicknameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
//                tableViewController?.nickname = currentUser.username
//            } else {
//                tableViewController?.nickname = userNicknameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            }
//            view.window?.rootViewController = tableViewController
//            view.window?.makeKeyAndVisible()
    }
    
}
