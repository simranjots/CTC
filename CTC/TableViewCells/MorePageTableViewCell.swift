//
//  MorePageTableViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-23.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class MorePageTableViewCell: UITableViewCell {
    
    @IBOutlet var moreCellView: UIView!
    @IBOutlet var optionIconImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet var nextImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleTableViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func styleTableViewCell() {
            
        //Style CellView
        moreCellView.layer.cornerRadius = moreCellView.frame.height / 6
        moreCellView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        moreCellView.layer.borderWidth = 1
    }
}
