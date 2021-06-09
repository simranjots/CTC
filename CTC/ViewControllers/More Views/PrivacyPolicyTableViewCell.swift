//
//  PrivacyPolicyTableViewCell.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-09.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class PrivacyPolicyTableViewCell: UITableViewCell {

    @IBOutlet var privacyPolicyHeading: UILabel!
    @IBOutlet var privacyPolicyBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
