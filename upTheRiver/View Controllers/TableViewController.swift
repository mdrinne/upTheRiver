//
//  TableViewController.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 6/4/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit
import SwiftSocket
import FirebaseAuth

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

class TableViewController: UIViewController {
    
    var HEADER = 16
    
    // Server Messages
    var PLAYER_ADDED = "playerAdded"
    var GAME_STARTED = "gameStarted"
    var NOTIFY_TURN = "notifyTurn"
    
    var port: Int = 0
    var owner: Int = 0
    var nickname: String = ""
    var currentUser: User!
    var clientConnection: TCPClient!
    var tablePlayers = [Player]()
    var connectionOpen = 0
    
    @IBOutlet weak var leabeTableButton: UIButton!
    
    @IBOutlet weak var endGameButton: UIButton!
    
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var myCard1: UIImageView!
    @IBOutlet weak var myCard2: UIImageView!
    @IBOutlet weak var myCard3: UIImageView!
    @IBOutlet weak var myCard4: UIImageView!
    
    @IBOutlet weak var currentTurnCardView: UIStackView!
    @IBOutlet weak var currentTurnCard1: UIImageView!
    @IBOutlet weak var currentTurnCard2: UIImageView!
    @IBOutlet weak var currentTurnCard3: UIImageView!
    @IBOutlet weak var currentTurnCard4: UIImageView!
    
    @IBOutlet weak var redBlackStackView: UIStackView!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let dispatchQueue = DispatchQueue(label: "serverListener", qos: .background)
            dispatchQueue.async {
                self.serverListener()
            }
            
            setUpElements()
            addPlayer()
    }
    
    func setUpElements() {
        if owner != 1 {
            startGameButton.isHidden = true
        }
        Utilities.styleButton50Radius(button: redButton)
        Utilities.styleButton50Radius(button: blackButton)
        redBlackStackView.isHidden = true
    }
    
    func sendMsg(msg: String) {
        let msg_len = msg.count
        let header_msg = String(msg_len) + String.init(repeating: " ", count: HEADER - String(msg_len).count)
        switch clientConnection.send(string: header_msg) {
        case .success:
            print("[HEADER_MSG SENT] message length successfully sent")
            switch clientConnection.send(string: msg) {
            case .success:
                print("[MSG SENT] message successfully sent")
            case .failure(let error):
                print("[ERROR] \(error): failure to send message")
            }
        case .failure(let error):
            print("[ERROR] \(error): failure to send message length")
        }
    }
    
    func playerAdded(response: [String]) {
        self.tablePlayers.append(Player(uid: response[1], nickname: response[2], fullName: response[3]))
        print("[PLAYER ADDED] added player")
    }
    
    func roundOneTurnSetup(player: String) {
        if Auth.auth().currentUser!.uid == player {
            DispatchQueue.main.async {
                UIView.transition(with: self.view, duration: 1, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                    self.currentTurnCardView.isHidden = true
                })
                UIView.transition(with: self.view, duration: 1, options: .transitionCrossDissolve, animations: {
                    self.redBlackStackView.isHidden = false
                })
            }
        }
    }
    
    func notifyTurn(turnDetails: [String]) {
        switch turnDetails[1] {
        case "1":
            roundOneTurnSetup(player: turnDetails[2])
        default:
            print("[TURN NOTIFIER] round not handled yet")
        }
    }
    
    func responseHandler(response: [String]) {
        switch response[0] {
            
        case PLAYER_ADDED:
            playerAdded(response: response)
            
        case GAME_STARTED:
            print("[GAME STARTED]")
        
        case NOTIFY_TURN:
            notifyTurn(turnDetails: response)
            
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
            if let data = clientConnection.read(HEADER, timeout: 30) {
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
        let add_player_msg = "addPlayer;\(currentUser.uid);\(nickname);\(currentUser.fullName)"
        sendMsg(msg: add_player_msg)
    }
    
    @IBAction func startGameButtonTapped(_ sender: Any) {
        let start_game_msg = "startGame"
        sendMsg(msg: start_game_msg)
        startGameButton.isHidden = true
    }
    
    @IBAction func endGameButtonTapped(_ sender: Any) {
        print("[END GAME TAPPED]")
//        let close_table_msg = "closeTable"
//        let msg_len = close_table_msg.count
//        let header_msg = String(msg_len) + String.init(repeating: " ", count: HEADER - String(msg_len).count)
//        switch clientConnection.send(string: header_msg) {
//        case .success:
//            print("[HEADER_MSG SENT] message length successfully sent")
//            switch clientConnection.send(string: close_table_msg) {
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
