//
//  TabBarViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-24.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class MaintabBarViewController: UITabBarController, UITabBarControllerDelegate {

    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Set homeScreen button in foreground before View did load
    override func viewWillAppear(_ animated: Bool) {
        self.delegate = self
        self.selectedIndex = 2
        setupMiddleButton()
    }
    
    //Button setup for Home Screen
    func setupMiddleButton() {
        
        //Set position and size
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 35, y: -25, width: 80, height: 80))
        
        //Set properties
        middleButton.setBackgroundImage(UIImage(named: "home-2"), for: .normal)
        Utilities.addShadowToButton(middleButton)
        
        //Set in subView
        self.tabBar.addSubview(middleButton)
        middleButton.addTarget(self, action: #selector(homeButtonTapped), for: .allTouchEvents)
        self.view.layoutIfNeeded()
    }
    
    //MARK: - Selector
    
    //Set tapping index for homescreen
    @objc func homeButtonTapped(sender: UIButton) {
        self.selectedIndex = 2
    }
}
