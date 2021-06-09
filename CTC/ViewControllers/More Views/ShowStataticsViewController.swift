//
//  ShowStataticsViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-08.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class ShowStataticsViewController: UIViewController {

    @IBOutlet var stataticsVCTableView: UITableView!
    
    //Dummy data for tableview
    let activityName = ["Meditation", "Practicing Guitar", "Reading", "Jogging", "Running"]
    let numberOfDaysActivityPracticed = ["110", "120", "130", "140", "150"]
    let activityTagLine = ["Lorem ipsum dolor sit amet.",
                           "Lorem ipsum dolor sit amet.",
                           "Lorem ipsum dolor sit amet.",
                           "Lorem ipsum dolor sit amet.",
                           "Lorem ipsum dolor sit amet."]
    let daysSinceStartedText = ["50", "100", "150", "200", "250"]
    let thisMonthText = ["12", "10", "15", "20", "25"]
    let streakText = ["3","7","5","20","24"]
    let progressPercentage = ["55%", "20%", "65%", "70%", "95%"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stataticsVCTableView.delegate = self
        stataticsVCTableView.dataSource = self
    }
}

extension ShowStataticsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.stataticsTableViewCell, for: indexPath) as! StataticsTableViewCell
        
        cell.activityHeaderTitleLabel.text = activityName[indexPath.row]
        cell.howManyDaysActivityPracticedLabel.text = numberOfDaysActivityPracticed[indexPath.row]
        cell.tagLineLabel.text = activityTagLine[indexPath.row]
        
        cell.daysSinceStartedLabel.text = daysSinceStartedText[indexPath.row]
        cell.activityPracticedForThisMonthLabel.text = thisMonthText[indexPath.row]
        cell.streakLabel.text = streakText[indexPath.row]
        cell.percentageLabel.text = progressPercentage[indexPath.row]
        
        cell.daysLabelTitle.text = "Days"
        cell.daysSinceStartedLabelTitle.text = "Days Since Started"
        cell.thisMonthLabelTitle.text = "This Month"
        cell.streakLabelTitle.text = "Streak"
        
        
        return cell
    }
    
    
    
}





