//
//  ProfilePageViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-16.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.styleTextField(nameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)

    }
    


}
