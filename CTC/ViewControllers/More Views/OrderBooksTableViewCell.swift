//
//  OrderBooksTableViewCell.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-09.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class OrderBooksTableViewCell: UITableViewCell {

    @IBOutlet var orderBooksView: UIView!
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var bookDescriptionLabel: UILabel!
    @IBOutlet var bookPriceLabel: UILabel!
    @IBOutlet var bookPurchaseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleViewAndButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func styleViewAndButton() {
        
        Utilities.styleButton(bookPurchaseButton)
        
        //orderBooksView.layer.cornerRadius = 6
        orderBooksView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        orderBooksView.layer.borderWidth = 1
        orderBooksView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        orderBooksView.layer.shadowOpacity = 0.9
        orderBooksView.layer.shadowOffset = .zero
        orderBooksView.layer.shadowRadius = 4
    }

}
