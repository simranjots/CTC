//
//  HomeVCTableViewCell.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-10.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class HomeVCTableViewCell: UITableViewCell {

    @IBOutlet var homeScreenTableCellView: UIView!
    @IBOutlet var activityImageView: UIImageView!
    @IBOutlet var activityNameLabel: UILabel!
    @IBOutlet var tagLineLabel: UILabel!
    @IBOutlet var starButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        homeScreenTableCellView.layer.cornerRadius = homeScreenTableCellView.frame.height / 7
        homeScreenTableCellView.layer.borderColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
        homeScreenTableCellView.layer.borderWidth = 2

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func starButtonTapped(_ sender: Any) {
    
    
    }
    
}
