//
//  MorePageTableViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-23.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class MorePageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var optionIconImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
