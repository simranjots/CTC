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
        guard let emailIcon = UIImage(named: "email") else { return }
        Utilities.addTextFieldImage(textField: emailTextField, andImage: emailIcon)
    }
    
    
    //MARK: - IBAction
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
    
//        print("Tapped")
//        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let auth = Auth.auth()
//        auth.sendPasswordReset(withEmail: email) { (error) in
//
//            if error != nil {
//                self.showAlert(title: "Error!", message: error!.localizedDescription, buttonTitle: "Try Again")
//                print("errror")
//
//            } else {
//                let alert = UIAlertController(title: "Hurray!", message: "A password reset request link has been sent on your email. Please check your inbox.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//                NSLog("The \"OK\" alert occured.")
//                }))
//                self.present(alert, animated: true, completion: nil)
//                self.emailTextField.text = ""
//                print("working fine")
//            }
//        }
//    }
    }
}
