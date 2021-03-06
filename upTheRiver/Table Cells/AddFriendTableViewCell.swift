//
//  AddFriendTableViewCell.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 5/29/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit

protocol TableViewAddFriend{
    func onClickAdd(index: Int)
}

class AddFriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addFriendFullNameLabel: UILabel!
    
    @IBOutlet weak var addFriendUsernameLabel: UILabel!
        
    @IBOutlet weak var addFriendAddButton: UIButton!
    
    var cellDelegate: TableViewAddFriend?
    
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addFriendAddButtonTapped(_ sender: Any) {
        cellDelegate?.onClickAdd(index: (index?.row)!)
    }
}
