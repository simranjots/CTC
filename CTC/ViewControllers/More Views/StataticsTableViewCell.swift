//
//  StataticsTableViewCell.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-08.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class StataticsTableViewCell: UITableViewCell {
    
    //Tablview Views
    @IBOutlet var stataticsVCMainContainer: UIView!
    @IBOutlet var headerTitleView: UIView!
    @IBOutlet var circularBarAndStataticsView: UIView!
    @IBOutlet var circularProgressBarView: StataticsViewProgressBar!
    
    
    //TableView Labels
    @IBOutlet var activityHeaderTitleLabel: UILabel!
    @IBOutlet var tagLineLabel: UILabel!
    @IBOutlet var howManyDaysActivityPracticedLabel: UILabel!
    @IBOutlet var daysSinceStartedLabel: UILabel!
    @IBOutlet var activityPracticedForThisMonthLabel: UILabel!
    @IBOutlet var streakLabel: UILabel!
    @IBOutlet var percentageLabel: UILabel!
    
    //TableView Label Titles
    @IBOutlet var daysLabelTitle: UILabel!
    @IBOutlet var daysSinceStartedLabelTitle: UILabel!
    @IBOutlet var streakLabelTitle: UILabel!
    @IBOutlet var thisMonthLabelTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleProgressBarColors()
        styleViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Style progressbar
    func styleProgressBarColors() {
        
        circularProgressBarView.trackColor = Utilities.primaryBorderColor
        circularProgressBarView.progressColor = Utilities.primaryTextColor
        circularProgressBarView.setProgressWithAnimation(duration: 1.0, value: 0.5)
    }
    
    //Style Views
    func styleViews() {
        
        //Set properties of activityTitleView
        headerTitleView.layer.cornerRadius = headerTitleView.frame.height / 4
        headerTitleView.layer.borderColor = Utilities.primaryBorderColor.cgColor
        headerTitleView.layer.borderWidth = 2
        
        //Set properties of ProgressView
        circularBarAndStataticsView.layer.borderColor = Utilities.primaryTextColor.cgColor
        circularBarAndStataticsView.layer.borderWidth = 2
    
    }
}

