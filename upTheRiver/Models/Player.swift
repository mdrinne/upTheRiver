//
//  Player.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 6/1/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import Foundation

class Player {
    let fullName: String
    let nickname: String
    let uid: String
    
    init(fullName: String, nickname: String, uid: String) {
        self.fullName = fullName
        self.nickname = nickname
        self.uid = uid
    }
}
