//
//  HistoryRecordTableViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-03-08.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class HistoryRecordTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let no = [1,2,3,4]
    var noOfPages: Int!
    var historyData: [PracticeHistory]?
    
    @IBOutlet weak var CardPageControl: UIPageControl!
    
    @IBOutlet weak var HistoryCollectionView: HistoryCardCollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        HistoryCollectionView.delegate = self
        HistoryCollectionView.dataSource = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    @IBAction func nextPageButtonTapped(_ sender: Any) {
        
        let nextIndex = min(CardPageControl.currentPage + 1, noOfPages-1)
        print("Next index : \(nextIndex)")
        let indexPath = IndexPath(item: nextIndex, section: 0)
        print("index Path:  \(indexPath)")
        CardPageControl.currentPage = nextIndex
        HistoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }
    
    @IBAction func prevPageButtonTapped(_ sender: Any) {
        
        let prevIndex = max(CardPageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        CardPageControl.currentPage = prevIndex
        HistoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyData!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath) as! HistoryCardCollectionViewCell
        cell.backgroundColor = .gray
//        print(no[indexPath.item])
        print("index path in function : \(indexPath)")
        print("Data : \(historyData?.count)")
        let history = historyData![indexPath.item]
        
        
        
        var statusString = history.com_del_flag == true ? "Completed On : " : "Deleted On : "
        statusString = statusString + "\(((history.date!) as Date).dateFormateToString()!)"
        let trackingDays = history.td
        let daySinceStarted = history.dss
//        let vrf = Float(trackingDays) / Float(daySinceStarted == 0 ? 1 : daySinceStarted)
//        print(vrf)
        let percentage = (Float(trackingDays) / Float(daySinceStarted == 0 ? 1 : daySinceStarted)) * 100
        
        
        cell.PracticeNameLabel.text = history.practice_name
        cell.statusLabel.text = statusString
        cell.percentageLabel.text = "Your Score : \(Int(percentage))"
        cell.percentageProgressView.progress = percentage / 100
        cell.totalDaysLabel.text = "\(daySinceStarted)"
        cell.trackingDaysLabel.text = "\(trackingDays)"
        
        return cell
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        CardPageControl.currentPage = Int(x / HistoryCollectionView.frame.width)
        
        
        //MARK: for bigger current page dot
        
        
//        // on each dot, call the transform of scale 1 to restore the scale of previously selected dot
//        
//        CardPageControl.subviews.forEach {
//            $0.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }
//        
//        // transform the scale of the current subview dot, adjust the scale as required, but bigger the scale value, the downward the dots goes from its centre.
//        // You can adjust the centre anchor of the selected dot to keep it in place approximately.
//        
//        let centreBeforeScaling = self.CardPageControl.subviews[self.CardPageControl.currentPage].center
//        
//        self.CardPageControl.subviews[self.CardPageControl.currentPage].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//        
//        
//        // Reposition using autolayout
//        
//        self.CardPageControl.subviews[self.CardPageControl.currentPage].translatesAutoresizingMaskIntoConstraints = false
//        
//        self.CardPageControl.subviews[self.CardPageControl.currentPage].centerYAnchor.constraint(equalTo: self.CardPageControl.subviews[0].centerYAnchor , constant: 0)
//        
//        self.CardPageControl.subviews[self.CardPageControl.currentPage].centerXAnchor.constraint(equalTo: self.CardPageControl.subviews[0].centerXAnchor , constant: 0)
//        
//        
////            self.CardPageControl.subviews[self.CardPageControl.currentPage].layer.anchorPoint = centreBeforeScaling
//        
//        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
