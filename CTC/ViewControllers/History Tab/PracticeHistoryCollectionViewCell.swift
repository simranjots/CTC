//
//  PracticeHistoryCollectionViewCell.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-30.
//  Copyright © 2021 ConnectToTheCore. All rights reserved.
//

import UIKit

class PracticeHistoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var histotyContainerView: UIView!
    @IBOutlet var practiceNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var circularProgressBarView: CircularProgressView!
    @IBOutlet var trackingDaysLabel: UILabel!
    @IBOutlet var daysSinceStartedLabel: UILabel!
    @IBOutlet var percentageLabel: UILabel!
    
}
