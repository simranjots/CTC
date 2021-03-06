//
//  ResetPasswordViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-22.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Texfield and Button stylling
        Utilities.styleTextField(emailTextField)
        Utilities.styleButton(resetPasswordButton)
        guard let emailIcon = UIImage(named: "Email") else { return }
        Utilities.addTextFieldImage(textField: emailTextField, andImage: emailIcon)
       // Utilities.addShadowToButton(resetPasswordButton)
    }
    
    
    //MARK: - IBAction
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                self.showAlert(title: "Error!", message: error!.localizedDescription, buttonTitle: "Try Again")
            } else {
                
                self.showAlertwithDismis(title:"Hurray!", message: "A password reset request link has been sent to your email. Please check your inbox.", buttonTitle: "OK")
                self.navigationController?.popViewController(animated: true)
                self.emailTextField.text = ""
            }
        }
    }
}
