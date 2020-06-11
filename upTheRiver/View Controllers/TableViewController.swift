//
//  TableViewController.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 6/4/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit
import SwiftSocket

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

class TableViewController: UIViewController {
    
    var HEADER = 16
    
    // Server Messages
    var PLAYER_ADDED = "playerAdded"
    
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
    
    @IBOutlet weak var endGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let dispatchQueue = DispatchQueue(label: "serverListener", qos: .background)
            dispatchQueue.async {
                self.serverListener()
            }
            addPlayer()
    }
    
    func responseHandler(response: [String]) {
        switch response[0] {
        case PLAYER_ADDED:
            self.tablePlayers.append(Player(uid: response[1], nickname: response[2], fullName: response[3]))
            print("[PLAYER ADDED] added player")
        default:
            print("[RESPONSE HANDLER] no case yet")
        }
    }
    
    func convertToInt(msg: String) -> Int {
        var str = ""
        for i in 0...msg.count {
            if msg[i] == " " {
                break
            } else {
                str += msg[i]
            }
        }
        return Int(str)!
    }

    func serverListener() {
        print("[SERVER LISTENER STARTED] in background")
        while connectionOpen == 1 {
            print("[TEST STOPPER]")
            if let data = clientConnection.read(HEADER, timeout: 180) {
                if let response = String(bytes: data, encoding: .utf8) {
                    print("[SERVER LISTENER] \(response)")
                    let msg_len = convertToInt(msg: response)
                    if let data = clientConnection.read(msg_len) {
                        if let response = String(bytes: data, encoding: .utf8) {
//                            let responseArray = response.split(separator: ";")
                            let responseArray = response.components(separatedBy: ";")
                            print(responseArray)
                            responseHandler(response: responseArray)
                        }
                    }
                }
            }

        }
    }
    
    func addPlayer() {
        print("[ADD PLAYER STARTED]")
        let add_player_message = "addPlayer;\(currentUser.uid);\(nickname);\(currentUser.fullName)"
        let msg_len = add_player_message.count
//        print(msg_len)
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
    
    @IBAction func endGameButtonTapped(_ sender: Any) {
        print("[END GAME TAPPED]")
//        let close_table_message = "closeTable"
//        let msg_len = close_table_message.count
//        let header_msg = String(msg_len) + String.init(repeating: " ", count: HEADER - String(msg_len).count)
//        switch clientConnection.send(string: header_msg) {
//        case .success:
//            print("[HEADER_MSG SENT] message length successfully sent")
//            switch clientConnection.send(string: close_table_message) {
//            case .success:
//                print("[PLAYER ADDED] you successfully closed the table")
//                clientConnection.close()
//                transitionToHome()
//            case .failure(let error):
//                print("[ERROR] \(error): failure to be added to table")
//            }
//        case .failure(let error):
//            print("[ERROR] \(error): failed to send message length")
//        }
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}
