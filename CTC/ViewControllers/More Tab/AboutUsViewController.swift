//
//  AboutUsViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-08.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    fileprivate struct AboutAuthors {
        let authorNames: [String]
        let authorsImages: [String]
        let description1: [String]
        let description2: [String]
    }
    
    fileprivate let aboutAuthorsDetails = [ AboutAuthors(
        authorNames: ["Kim White", "Teresa Easler"],
        authorsImages: ["Kim White", "Teresa Easler"],
        description1: [
        "Due to an injury, Kim retired from professional running but years later wanted to continue again, this time as a solution o his health. He was getti-",
        "A few years back, she was feeling ‘off track’ with some of her regular practices—yoga and meditation, in perticular. She was hard on herself"
        ],
        description2: [
        "ng when she didn’t do these short of breath, he'd put on a lot of weight, and found it hard to bend over and tie his laces. After getting back in the game, he set a goal to run 200 days in a year. There was one rule: he wasn’t going to force himself. In 2016, he ran 201 days—55%—of the year. That number felt good with him and he totally enjoyed the process. He knew he was on to something. Tracking the practice with 201 out of 365 as a goal was what he needed—success without stress or pressure!",
        "every day. She saw success as all or nothing This created inner-tension; the ‘missing days’ drove her into a negative mindset. Teresa decided to apply Kim’s 201 magic number to her practices. His formula worked. Success followed, and she soon added other practices.Together they decided to share this 201 Day Achievement Principle with the world through a Book, Companion Tracking Journal and iPhone APP."
        ]
    )]
    
    
    @IBOutlet var aboutAuthorsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About The Authors"
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 330
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutAuthorsDetails[aboutAuthorsTableView.tag].authorNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.aboutAuthorTableViewCell) as! AboutUsTableViewCell
        
        cell.authorsNameLabel.text = aboutAuthorsDetails[aboutAuthorsTableView.tag].authorNames[indexPath.row]
        cell.authorsImageView.image = UIImage(named: aboutAuthorsDetails[aboutAuthorsTableView.tag].authorsImages[indexPath.row])
        cell.description1.text = aboutAuthorsDetails[aboutAuthorsTableView.tag].description1[indexPath.row]
        cell.description2.text = aboutAuthorsDetails[aboutAuthorsTableView.tag].description2[indexPath.row]
        
        return cell
        
    }
    
}
