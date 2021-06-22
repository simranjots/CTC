//
//  OrderBooksViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-09.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class OrderBooksViewController: UIViewController {

    @IBOutlet var orderBooksTableView: UITableView!
    
    //@IBOutlet var orderBooksCollectionView: UICollectionView!
    
    let booksName = ["201 Day Achievement Principle Book", "201 DAP Companion Tracking Journal", "Book + Journal Bundle"]
    
    let booksImageView = ["201DAPBook", "trackingJournal", "bookAndJournal"]
    
    let booksDescription = [
        "The 201 Day Achievement Principle Book explains the origin of this powerful system offering a whole new perspective on achievement without the typical pressure.",
        "Includes a detailed PRACTICE CLARIFIER exercise a space to glue your Vison Board inside and 52 week charts to track your practices, wins and personal insights.",
        "Both books together are $39.94. However, this SPECIAL OFFER is priced $32.97(save $6.97) !!! PLUS shipping is included in this special offer."
    ]
    
    let booksPrice = ["$19.97 USD + FREE Shipping", "$19.97 USD + FREE Shipping", "$32.97 USD + FREE Shipping(Reg. $39.94)"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderBooksTableView.delegate = self
        orderBooksTableView.dataSource = self
    }
}


//MARK: - Extension for TableView
extension OrderBooksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 375
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.orderBooksTableViewCell, for: indexPath) as! OrderBooksTableViewCell
        
        cell.bookTitleLabel.text = booksName[indexPath.row]
        cell.bookImageView.image = UIImage(named: booksImageView[indexPath.row])
        cell.bookDescriptionLabel.text = booksDescription[indexPath.row]
        cell.bookPriceLabel.text = booksPrice[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch booksName[indexPath.row] {
        
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

