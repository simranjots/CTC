//
//  ShopBooksViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-21.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class ShopBooksViewController: UIViewController {
    
    @IBOutlet var shopBooksCollectionView:UICollectionView!
    
    //MARK: - Books Data
    let booksTitle = ["201 Day Achievement Principle Book", "201 DAP Companion Tracking Journal", "Book + Journal Bundle"]
    
    let booksCoverImages = ["201DAPBook", "trackingJournal", "bookAndJournal"]
    
    let booksDescription = [
        "The 201 Day Achievement Principle Book explains the origin of this powerful system offering a whole new perspective on achievement without the typical pressure.",
        "Includes a detailed PRACTICE CLARIFIER exercise a space to glue your Vison Board inside and 52 week charts to track your practices, wins and personal insights.",
        "Both books together are $39.94. However, this SPECIAL OFFER is priced $32.97(save $6.97) !!! PLUS shipping is included in this special offer."
    ]
    
    let booksPrice = ["$19.97 USD + FREE Shipping", "$19.97 USD + FREE Shipping", "$32.97 USD + FREE Shipping(Reg. $39.94)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopBooksCollectionView.delegate = self
        shopBooksCollectionView.dataSource = self
    }
}

//MARK: - Extension for ShopBooksViewController

extension ShopBooksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = shopBooksCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.orderBooksCollectionViewCell, for: indexPath) as! ShopBooksCollectionViewCell
        
        cell.booksTitleLabel.text = booksTitle[indexPath.row]
        cell.booksCoverImageView.image = UIImage(named: booksCoverImages[indexPath.row])
        cell.booksDescriptionLabel.text = booksDescription[indexPath.row]
        cell.priceLabel.text = booksPrice[indexPath.row]
        
        //View styles
        cell.containerView.layer.cornerRadius = cell.containerView.frame.height / 30
        Utilities.addShadowAndBorderToView(cell.containerView)
        //cell.containerView.layer.borderColor = UIColor.white.cgColor
        Utilities.styleButton(cell.purchaseLabel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 333, height: 399)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        shopBooksCollectionView.deselectItem(at: indexPath, animated: true)
        
        switch booksTitle[indexPath.row] {
        case "201 Day Achievement Principle Book":
            UIApplication.shared.open(URL(string: "https://www.201dayachievementprinciple.com/offers/EttfqUXp/checkout")!, options: [:], completionHandler: nil)
            break
            
        case "201 DAP Companion Tracking Journal":
            UIApplication.shared.open(URL(string: "https://www.201dayachievementprinciple.com/offers/jKCKCNii/checkout")!, options: [:], completionHandler: nil)
            break
            
        case "Book + Journal Bundle":
            UIApplication.shared.open(URL(string: "https://www.201dayachievementprinciple.com/offers/vz22JGLZ/checkout")!, options: [:], completionHandler: nil)
            break
            
        default:
            print("URL is not available.")
            break
        }
    }
}

