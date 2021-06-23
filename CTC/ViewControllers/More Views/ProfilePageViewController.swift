//
//  ProfilePageViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-16.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit
import MobileCoreServices

class ProfilePageViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var updateProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleElements()
        
    }
    
    
    //MARK: - Stylling
    func styleElements() {
        
        //Style textFiels and button
        Utilities.addBottomLineToTextField(nameTextField)
        Utilities.addBottomLineToTextField(emailTextField)
        Utilities.addBottomLineToTextField(passwordTextField)
        Utilities.styleButton(updateProfileButton)
        
        //Style profile Image
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderColor = Utilities.primaryBorderColor.cgColor
        profileImageView.layer.borderWidth = 2
        
    }
    
    //MARK: - IBActions
    @IBAction func imageEditButtonTapped(_ sender: UIButton) {
        actionSheet()
    }
    
    @IBAction func updateProfileButtonTapped(_ sender: UIButton) {
        
    }
    
    
    //MARK: - Helper functions
    func actionSheet() {
        
        let alert = UIAlertController(title: "Choose Image from: ", message: nil, preferredStyle: .actionSheet)
        
        //To open camera
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (handler) in
            self.openCamera()
        }))
        
        //To open gallery
        alert.addAction(UIAlertAction(title: "Open Gallery", style: .default, handler: { (handler) in
            self.openGallery()
        }))
        
        //To Cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (handler) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let image = UIImagePickerController()
            image.sourceType = .camera
            image.allowsEditing = true
            image.delegate = self
            image.mediaTypes = [kUTTypeImage as String]
            present(image, animated: true)
        }
    }
    
    func openGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let image = UIImagePickerController()
            image.sourceType = .photoLibrary
            image.allowsEditing = true
            image.delegate = self
            present(image, animated: true)
        }
    }
    
    
}

//MARK: - Extension for UIImagePickerViewController

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\(info)")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}


