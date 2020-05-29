//
//  AddFriendTableViewCell.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 5/29/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit

class AddFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var userFullNameLabel: UILabel!
    
    @IBOutlet weak var userUsernameLabal: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
