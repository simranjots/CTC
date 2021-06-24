//
//  ShowPercentageCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-10.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class ShowPercentageCell: UITableViewCell {
    
    @IBOutlet weak var TrackingDayLabel: UILabel!
    @IBOutlet weak var ResolutionTextLabel: UILabel!
    @IBOutlet weak var PercentageLabel: UILabel!
    @IBOutlet weak var PercentageProgressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PercentageProgressView.progressTintColor = Theme.secondaryColor
        PercentageProgressView.layer.cornerRadius = PercentageProgressView.frame.height/2
        PercentageProgressView.clipsToBounds = true
        PercentageProgressView.layer.sublayers![1].cornerRadius = PercentageProgressView.frame.height/2
        PercentageProgressView.subviews[1].clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
