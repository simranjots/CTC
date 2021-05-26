//
//  HistoryHeaderCellTableViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-03-15.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class HistoryHeaderCellTableViewCell: UITableViewCell {

    @IBOutlet weak var HeaderTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = Theme.navigationBarBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
