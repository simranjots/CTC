//
//  ActivityTrackTableViewCell.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-08.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class ActivityTrackTableViewCell: UITableViewCell {

    @IBOutlet var activityTrackView: UIView!
    @IBOutlet var activityDateLabel: UILabel!
    @IBOutlet var activityNotesTextView: UITextView!
    @IBOutlet var practicedDaysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityTrackView.layer.cornerRadius = activityTrackView.frame.height / 10
        activityTrackView.layer.borderColor = #colorLiteral(red: 0, green: 0.7097216845, blue: 0.6863465309, alpha: 1)
        activityTrackView.layer.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
