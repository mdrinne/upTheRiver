//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 8/255, green: 201/255, blue: 147/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textfield.textColor = UIColor.white
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 8/255, green: 201/255, blue: 147/255, alpha: 1)
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 8/255, green: 201/255, blue: 147/255, alpha: 1).cgColor
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.init(red: 8/255, green: 201/255, blue: 147/255, alpha: 1)
    }
    
    static func styleLabelPrimary(  label:UILabel) {
        
        label.textColor = UIColor.init(red: 8/255, green: 201/255, blue: 147/255, alpha: 1)
        
    }

}
