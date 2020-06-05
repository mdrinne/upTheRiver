//
//  User.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 5/31/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import Foundation

class User {

    let fullName: String
    let username: String
    let uid: String
    let inGame: Int
    
    init(fullName: String, username: String, uid: String, inGame: Int) {
        self.fullName = fullName
        self.username = username
        self.uid = uid
        self.inGame = inGame
    }
}
