//
//  HomeScreenViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-10.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    struct homeScreenDummyData {
        let activityName: [String]
        let tagLine: [String]
        let activityImages: [String]
    }

    //Dummy data
    let dummyData = [homeScreenDummyData(
                        activityName: ["Meditation", "Reading", "Exercise", "Jogging", "Diet",
                                       "Music", "Yoga", "No Cheese", "Walking", "Healthy Food"],
                        tagLine: ["Lorem ipsum dolor sit amet.","Lorem ipsum dolor sit amet.",
                                  "Lorem ipsum dolor sit amet.", "Lorem ipsum dolor sit amet.",
                                  "Lorem ipsum dolor sit amet.", "Lorem ipsum dolor sit amet.",
                                  "Lorem ipsum dolor sit amet.", "Lorem ipsum dolor sit amet.",
                                  "Lorem ipsum dolor sit amet.", "Lorem ipsum dolor sit amet."],
                        activityImages: ["Meditation", "reading", "Exercise-1", "jogging", "diet", "Music", "Yoga", "Cheese", "Walking", "Salad"]
    )]
    
    @IBOutlet var homeScreenTableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeScreenTableView.dataSource = self
        homeScreenTableView.delegate = self
        
        styleDateLabelView()
        
    }
    
    func styleDateLabelView() {
        
        dateView.layer.cornerRadius = dateView.frame.height / 6
        dateView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        dateView.layer.borderWidth = 1
        dateLabel.text = "Sun June 13, 2021"
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    
    }
    
}

extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData[homeScreenTableView.tag].activityName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeScreenTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.homeVCTableViewCell, for: indexPath) as! HomeVCTableViewCell
        
        cell.activityNameLabel?.text = dummyData[homeScreenTableView.tag].activityName[indexPath.row]
        cell.activityImageView?.image = UIImage(named: dummyData[homeScreenTableView.tag].activityImages[indexPath.row])
        cell.tagLineLabel?.text = dummyData[homeScreenTableView.tag].tagLine[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.activityDetailsViewController) as! ActivityDetailsViewController
        
        VC.activityName = dummyData[homeScreenTableView.tag].activityName[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
}
