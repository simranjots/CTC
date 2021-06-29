//
//  HistoryCardCollectionViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-03-11.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class HistoryCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var PracticeNameLabel: UILabel!
    @IBOutlet weak var statusDate: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var trackingDaysLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var percentageProgressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet var cardContainerView: UIView!
    
    override func awakeFromNib() {
        
        
        Utilities.addShadowAndBorderToView(cardBackgroundView)
        //cardBackgroundView.setPopupView()
        //PracticeNameLabel.setPopUpTitle()
        //percentageProgressView.layer.cornerRadius = percentageProgressView.frame.height / 2
    }
}
