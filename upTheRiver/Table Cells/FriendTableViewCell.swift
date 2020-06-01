//
//  FriendTableViewCell.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 6/1/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var friendFullNameLabel: UILabel!
    
    @IBOutlet weak var friendUsernameLabel: UILabel!
    
    @IBOutlet weak var friendJoinButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
