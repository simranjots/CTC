//
//  OnboardingEndCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-04-16.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class OnboardingEndCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func awakeFromNib() {
        logInButton.loginButton()
        signUpButton.loginButton()
    }
    
}
