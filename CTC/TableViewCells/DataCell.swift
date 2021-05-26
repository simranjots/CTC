//
//  DataCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-10.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {
    
    
    @IBOutlet weak var ResolutionTextLabel: UILabel!
    @IBOutlet weak var PersonalNoteTextView: UITextView!
    @IBOutlet weak var TrackingDayLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
