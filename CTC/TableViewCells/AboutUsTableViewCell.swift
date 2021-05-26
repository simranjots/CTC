//
//  AboutUsTableViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-04-23.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class AboutUsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
