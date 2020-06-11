//
//  Player.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 6/1/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import Foundation

class Player {
    let uid: String
    let nickname: String
    let fullName: String
    
    init(uid: String, nickname: String, fullName: String) {
        self.uid = uid
        self.nickname = nickname
        self.fullName = fullName
    }
}
