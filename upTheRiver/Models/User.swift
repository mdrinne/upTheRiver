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
    
    init(fullName: String, username: String, uid: String) {
        self.fullName = fullName
        self.username = username
        self.uid = uid
    }
}
