//
//  AboutUsViewController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-04-23.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    
    @IBOutlet var aboutAuthorsTableView: UITableView!
    
    
    let authorNames = ["Kim White", "Teresa Easler"]
    let authorsImages = ["Kim White", "Teresa Easler"]
    let description1 = [
        "Due to an injury, Kim retired from professional running but years later wanted to continue again, this time as a solution",
        "A few years back, she was feeling ‘off track’ with some of her regular practices—yoga and meditation, in perticular."
    ]
    
    let description2 = [
        "to his health. He was getting short of breath, he'd put on a lot of weight, and found it hard to bend over and tie his laces. After getting back in the game, he set a goal to run 200 days in a year. There was one rule: he wasn’t going to force himself. In 2016, he ran 201 days—55%—of the year. That number felt good with him and he totally enjoyed the process. He knew he was on to something. Tracking the practice with 201 out of 365 as a goal was what he needed—success without stress or pressure!",
        "She was hard on herself when she didn’t do these things every day. She saw success as all or nothing. This created inner-tension; the ‘missing days’ drove her into a negative mindset. Teresa decided to apply Kim’s 201 magic number to her practices. His formula worked. Success followed, and she soon added other practices.Together they decided to share this 201 Day Achievement Principle with the world through a Book, Companion Tracking Journal and iPhone APP."
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About Authors"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authorNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.aboutAuthorTableViewCell) as! AboutUsTableViewCell
        
        cell.authorsImageView.image = UIImage(named: authorsImages[indexPath.row])
        cell.authorsNameLabel.text = authorNames[indexPath.row]
        cell.description1.text = description1[indexPath.row]
        cell.description2.text = description2[indexPath.row]
        
        return cell
        
    }
    
}
