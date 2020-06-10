//
//  TableViewController.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 6/4/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit
import SwiftSocket

class TableViewController: UIViewController {
    
    var HEADER = 16
    
    var port: Int = 0
    var owner: Int = 0
    var nickname: String = ""
    var currentUser: User!
    var clientConnection: TCPClient!
    var tablePlayers = [Player]()
    var connectionOpen = 0

    @IBOutlet weak var portLabel: UILabel!
    
    @IBOutlet weak var tableNameLabel: UILabel!
    
    @IBOutlet weak var leabeTableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        print(port)
//        sleep(1)
//        clientConnection = TCPClient(address: "192.168.1.249", port: Int32(port))
//        switch clientConnection.connect(timeout: 10) {
//        case .success:
//            connectionOpen = 1
            let dispatchQueue = DispatchQueue(label: "serverListener", qos: .background)
            dispatchQueue.async {
                self.serverListener()
            }
            print("connected")
            addPlayer()
//        case .failure(let error):
//            print("Failed to connect client on table port")
//            print(error)
//        }
    }
    
    func serverListener() {
        print("[SERVER LISTENER STARTED] in background")
//        while connectionOpen == 1 {
//            if let data = clientConnection.read(1024) {
//                if let response = String(bytes: data, encoding: .utf8) {
//                    print(response)
//                }
//            }
//
//        }
    }
    
    func addPlayer() {
        print("[ADD PLAYER STARTED]")
        let add_player_message = "addPlayer;\(currentUser.uid);\(nickname);\(currentUser.fullName)"
        let msg_len = add_player_message.count
        print(msg_len)
        let header_msg = String(msg_len) + String.init(repeating: " ", count: HEADER - String(msg_len).count)
        switch clientConnection.send(string: header_msg) {
        case .success:
            print("[HEADER_MSG SENT] message length successfully sent")
            switch clientConnection.send(string: add_player_message) {
            case .success:
                print("[PLAYER ADDED] you were successfully added to table")
            case .failure(let error):
                print("[ERROR] \(error): failure to be added to table")
            }
        case .failure(let error):
            print("[ERROR] \(error): failed to send message length")
        }
    }
}
