//
//  NavigationBar.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-22.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialNavigationBar()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialNavigationBar()
    }
    
    func initialNavigationBar() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 1.0
        self.barTintColor = Theme.navigationBarBackgroundColor
        self.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.titleTextAttributes = textAttributes
//
//        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Appbackground.png"), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.backgroundColor = UIColor.clear
//        navigationController?.navigationBar.barTintColor = UIColor.clear
        
        
        
        // MARK: Gradiat Color Sewt for naviagation Bar
        
        
//        let gradient = CAGradientLayer()
//        var bounds = self.bounds
//        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
//        gradient.frame = bounds
//        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
//        gradient.startPoint = CGPoint(x: 0, y: 0)
//        gradient.endPoint = CGPoint(x: 1, y: 0)
        
//        let gradient = CAGradientLayer()
//        let flareRed = UIColor(displayP3Red: 241.0/255.0, green: 39.0/255.0, blue: 17.0/255.0, alpha: 1.0)
//        let flareOrange = UIColor(displayP3Red: 245.0/255.0, green: 175.0/255.0, blue: 25.0/255.0, alpha: 1.0)
//        var bounds = self.bounds
//        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
//        gradient.frame = bounds
//        gradient.colors = [flareRed.cgColor, flareOrange.cgColor]
//        gradient.startPoint = CGPoint(x: 0, y: 0)
//        gradient.endPoint = CGPoint(x: 1, y: 0)
//        self.setBackgroundImage(gradient.createGradientImage(on: self), for: .default)

        
        // MARL: Gradient over
        
    }

}
