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
    
    let snapshotImages = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
    let howToUseDescription = [
        "Tap on the '+' icon to add new practice.",
        "1. Select a value from the list or tap on the edit icon to enter a customized value. 2. Select practice from the list or tap on the edit icon to enter customized practice. 3. Select starting date. 4. Enter words of encouragement. You can also generate random quotes by tapping on 'change' 5. Choose an appropriate image icon from the list. 6. Tap 'Add.'",
        "Now, you can see your selected practice on the Home screen. You can add 'n' numbers of such practices. Tap on the 'Star' if you have practiced today, and it will show your progress on the 'Activity Details' screen by tapping on practice.",
        "1. Practice name. 2. Percentage progress. 3. Number of days practiced. 4. Days since practice started. 5. Here, you can add your daily notes. 6. Tap on 'Star' if you have practiced today. 7. Tap 'Save.'",
        "Swipe right to left to delete the practice.",
        "Swipe left to right to edit the practice.",
        "To add reminder first, you have to edit the practice. Toggle the reminder switch, and it will open 'Reminder' screen.",
        "Now, Tap on the '+' icon and select desired day and time when you want reminders. You can add 'n' numbers of such reminders. Tap on 'Done' and then tap on 'Confirm.' Now, you will get reminder notification according to your setup.",
        "In this screen, you can see the progress of all the practices. 1. Practice Name. 2. Number of days you did practice. 3. Practice added to date. 4. Percentage Progress 5. Days since started. 6. How many days you did practice this month. 7. Practiced streak. (Auto reset if you don't do practice for two consecutive days.)",
        "'Activity Progress' screen gives you details about your daily notes and on which day you did practice.",
        "'Practice history' tab shows you completed and deleted practices list. You can also restore practice by tapping on the 'restore' button. Tap the' next' and 'previous' buttons to scroll the list."]
    
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
        
        cell.appSnapshotsImageView.image = UIImage(named: snapshotImages[indexPath.row])
        cell.useDescriptionLabel.text = howToUseDescription[indexPath.row]
        
        //View style
        Utilities.addBorderToView(cell.containerView)

        //ImageView styles
        cell.appSnapshotsImageView.layer.borderWidth = 1
        cell.appSnapshotsImageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 374, height: 605)
//    }
//
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let xCoordinate = targetContentOffset.pointee.x
        let pageNumber = xCoordinate / view.frame.width
        pageControl.currentPage = Int(pageNumber)
        
    }
    
}
