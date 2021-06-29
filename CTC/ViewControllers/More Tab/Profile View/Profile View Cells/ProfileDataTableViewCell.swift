//
//  ProfileDataTableViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-29.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class ProfileDataTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentTextLabel.setUnderLine()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
