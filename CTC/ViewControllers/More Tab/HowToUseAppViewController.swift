//
//  HowToUseAppViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-21.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class HowToUseAppViewController: UIViewController {

    
    //MARK: - Outlets
    @IBOutlet var howToUseCollectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    //MARK: - Images and Descriptions
    
    let snapshotImages = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        howToUseCollectionView.delegate = self
        howToUseCollectionView.dataSource = self
        
        pageControl.numberOfPages = snapshotImages.count
        pageControl.currentPage = 0

    }
}

//MARK: - Extension for collectionView

extension HowToUseAppViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snapshotImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = howToUseCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.howToUseCollectionViewCell, for: indexPath) as! HowToUseCollectionViewCell
        
        cell.appSnapshotsImageView.image = UIImage(named: "\(snapshotImages[indexPath.row]).jpg")
        
        //Style appSnapshotImageView
        cell.appSnapshotsImageView.layer.cornerRadius = cell.appSnapshotsImageView.frame.height / 25
        cell.appSnapshotsImageView.layer.shadowColor = UIColor.black.cgColor
        cell.appSnapshotsImageView.layer.shadowOpacity = 0.5
        cell.appSnapshotsImageView.layer.shadowOffset = CGSize(width: 0.0, height: 1.7)
        
        return cell
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let xCoordinate = targetContentOffset.pointee.x
        let pageNumber = xCoordinate / view.frame.width
        pageControl.currentPage = Int(pageNumber)

    }
    
}
