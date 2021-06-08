//
//  AboutUsTableViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-04-23.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class AboutUsTableViewCell: UITableViewCell {
    
    @IBOutlet var aboutAuthorsView: UIView!
    @IBOutlet var authorsNameLabel: UILabel!
    @IBOutlet var authorsImageView: UIImageView!
    @IBOutlet var description1: UILabel!
    @IBOutlet var description2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        authorsImageView.layer.cornerRadius = authorsImageView.frame.height / 2
        authorsImageView.layer.borderWidth = 3
        authorsImageView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
