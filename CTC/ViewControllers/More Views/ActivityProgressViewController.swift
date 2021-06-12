//
//  ActivityProgressViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-08.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class ActivityProgressViewController: UIViewController {

    
    //Outlets of Views and TableView
    @IBOutlet var circularProgressBar: CircularProgressBarView!
    @IBOutlet var activityTrackingTableView: UITableView!
    @IBOutlet var activityTitleHeaderView: UIView!
    @IBOutlet var progressView: UIView!
    @IBOutlet var tableViewHeader: UIView!
    
    //Outlets of Label
    @IBOutlet var activityNameLabel: UILabel!
    @IBOutlet var tagLineLabel: UILabel!
    @IBOutlet var howManyDaysPracticedLabel: UILabel!
    @IBOutlet var percentageLabel: UILabel!
    @IBOutlet var daysSinceStartedLabel: UILabel!
    @IBOutlet var howManyDaysPracticedForThisMonthLabel: UILabel!
    @IBOutlet var streakLabel: UILabel!
    
    //Dummy data for tableView
    let date = ["June 08, 2021", "June 07, 2021", "June 06, 2021", "June 05, 2021", "June 04, 2021"]
    let practicedDay = ["8", "7", "6", "5", "4"]
    let personalNotes = [
        "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleProgressBarColors()
        styleViews()
        
        activityTrackingTableView.dataSource = self
        activityTrackingTableView.delegate = self

    }
    
    //Style progressbar
    func styleProgressBarColors() {
        circularProgressBar.trackColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        circularProgressBar.progressColor = #colorLiteral(red: 0, green: 0.7097216845, blue: 0.6863465309, alpha: 1)
        circularProgressBar.setProgressWithAnimation(duration: 1.0, value: 0.5)
    }
    
    //Style Views
    func styleViews() {
        
        //Set properties of activityTitleView
        activityTitleHeaderView.layer.cornerRadius = activityTitleHeaderView.frame.height / 4
        activityTitleHeaderView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        activityTitleHeaderView.layer.borderWidth = 1
        activityTitleHeaderView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        activityTitleHeaderView.layer.shadowOpacity = 0.9
        activityTitleHeaderView.layer.shadowOffset = .zero
        activityTitleHeaderView.layer.shadowRadius = 4
        
        //Set properties of ProgressView
        progressView.layer.cornerRadius = progressView.frame.height / 10
        progressView.layer.borderColor = #colorLiteral(red: 0, green: 0.7097216845, blue: 0.6863465309, alpha: 1)
        progressView.layer.borderWidth = 1
        progressView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        progressView.layer.shadowOpacity = 0.9
        progressView.layer.shadowOffset = .zero
        progressView.layer.shadowRadius = 4
        
        
        //Set properties of tableView Header
        tableViewHeader.layer.cornerRadius = tableViewHeader.frame.height / 6
    }

}

extension ActivityProgressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return date.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.activityProgressTableViewCell, for: indexPath) as! ActivityTrackTableViewCell
        
        cell.activityDateLabel.text = date[indexPath.row]
        cell.activityNotesTextView.text = personalNotes[indexPath.row]
        cell.practicedDaysLabel.text = practicedDay[indexPath.row]

        return cell
    }
    
}
