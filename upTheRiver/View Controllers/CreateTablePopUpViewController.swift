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

class CreateTablePopUpViewController: UIViewController {

    @IBOutlet weak var tableNameTextField: UITextField!
    
    @IBOutlet weak var userNicknameTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }

    func setUpElements() {
        
        Utilities.styleTextField(tableNameTextField)
        Utilities.styleTextField(userNicknameTextField)
        Utilities.styleHollowButton(cancelButton)
        Utilities.styleFilledButton(createButton)
        popUpView.layer.cornerRadius = 20
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
        let client = TCPClient(address: "localhost", port: 25000)
        
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
                        transitionToTable(port: String(responseArray[1]))
                        
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
    
    func transitionToTable(port: String) {
        let tableViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tableViewController) as? TableViewController
        
        tableViewController?.port = port
        view.window?.rootViewController = tableViewController
        view.window?.makeKeyAndVisible()
    }
    
}
