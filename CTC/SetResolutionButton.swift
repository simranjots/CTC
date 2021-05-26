//
//  SetResolutionButton.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-18.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class SetResolutionButton: UIButton {

    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("No", for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = .red
        
        initButton()
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton(){
        
       self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 4
        
        backgroundColor = .red
        setTitleColor(UIColor.black, for: .normal)
//        setImage(UIImage(named: "No"), for: .normal)
        addTarget(self, action: #selector(SetResolutionButton.buttonPressed), for: .touchUpInside)
        
    }
    
    @objc func buttonPressed (){
        
        activateButton(bool: !isOn)
        
    }
    
    func activateButton(bool: Bool){
        
        isOn = bool
        
        let color = bool ? UIColor.green : UIColor.red
        let title = bool ? "Yes" : "No"
        let titleColor = bool ? UIColor.black : UIColor.black
        let imageIcon = bool ? UIImage(named: "Yes") : UIImage(named: "No")
        
//        setTitle(title, for: .normal)
        setImage(imageIcon, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
        
    }

}
