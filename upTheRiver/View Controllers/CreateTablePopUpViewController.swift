//
//  CreateTablePopUpViewController.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 6/1/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit

class CreateTablePopUpViewController: UIViewController {

    @IBOutlet weak var tableNameTextField: UITextField!
    
    @IBOutlet weak var userNicknameTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }

    func setUpElements() {
        
        Utilities.styleTextField(tableNameTextField)
        Utilities.styleTextField(userNicknameTextField)
        Utilities.styleHollowButton(cancelButton)
        Utilities.styleFilledButton(createButton)
        popUpView.layer.cornerRadius = 20
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != popUpView {
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func createTapped(_ sender: Any) {
        
    }
    
}
