//
//  DataHeaderCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-10.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class DataHeaderCell: UITableViewCell {
    
    
    @IBOutlet weak var LabelDate: UILabel!
    
    @IBOutlet weak var daysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
