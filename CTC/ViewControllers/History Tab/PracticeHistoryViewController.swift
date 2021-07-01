//
//  PracticeHistoryViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-30.
//  Copyright © 2021 ConnectToTheCore. All rights reserved.
//

import UIKit

class PracticeHistoryViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var practiceHistoryCollectionView: UICollectionView!
    
    @IBOutlet var previousButtonOutlet: UIButton!
    @IBOutlet var nextButtonOutlet: UIButton!
    @IBOutlet var restoreButtonOutlet: UIButton!
    
    //Dummy Data
    let practicesName = ["No Salt", "No Cheese", "Meditation", "Dieting", "Music"]
    let completedDateDetails = ["10/01/2021", "10/02/2021", "10/03/2021", "10/04/2021", "10/05/2021"]
    let percentageScore = ["50", "60", "70", "80", "90"]
    let progressBarPercentage = [0.5, 0.6, 0.7, 0.8, 0.9]
    let trackedDays = ["100", "150", "200", "250", "300"]
    let daysSinceStarted = ["150", "200", "250", "300", "350"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        practiceHistoryCollectionView.delegate = self
        practiceHistoryCollectionView.dataSource = self
        addShadowToButtons()
        
    }
    
    //MARK: - IBActions
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func restoreButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
    }
    
    //Style Buttons
    func addShadowToButtons() {
        Utilities.addShadowToButton(previousButtonOutlet)
        Utilities.addShadowToButton(nextButtonOutlet)
        Utilities.addShadowToButton(restoreButtonOutlet)
    }
}

//MARK: - Extension for UICollectionView

extension PracticeHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return practicesName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = practiceHistoryCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.practiceHistoryCollectionViewCell, for: indexPath) as! PracticeHistoryCollectionViewCell
        
        cell.practiceNameLabel.text = practicesName[indexPath.row]
        cell.dateLabel.text = "Completed On : \(completedDateDetails[indexPath.row])"
        cell.scoreLabel.text = "Your Score was : \(percentageScore[indexPath.row])%"
        cell.progressBar.progress = Float(progressBarPercentage[indexPath.row])
        cell.trackingDaysLabel.text = trackedDays[indexPath.row]
        cell.daysSinceStartedLabel.text = daysSinceStarted[indexPath.row]
        
        Utilities.addShadowAndBorderToView(cell.histotyContainerView)
        cell.histotyContainerView.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 369, height: 246)
//    }
}



