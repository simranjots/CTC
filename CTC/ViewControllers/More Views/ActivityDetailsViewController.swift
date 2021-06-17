//
//  ActivityDetailsViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-13.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    @IBOutlet var dateContainerView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var activityNameTextField: UITextField!
    @IBOutlet var stataticsView: UIView!
    @IBOutlet var circularProgressBar: ActivityDetailsProgressBarView!
    @IBOutlet var percentageLabel: UILabel!
    @IBOutlet var daysPracticedLabel: UILabel!
    @IBOutlet var daysSinceStartedLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var startButtonOutlet: UIButton!
    @IBOutlet var saveButtonOutlet: UIButton!
    
    var activityName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "Activity Details"
        styleElements()
        dataFromHomeViewContoller()
    }
    
    
    //Style textFields, textView, Button and Views
    func styleElements() {
        
        //Style textfields, textView and imageView
        Utilities.styleTextField(activityNameTextField)
        Utilities.styleTextView(notesTextView)
        
        
        //Style buttons
        Utilities.styleButton(saveButtonOutlet)
        
        //Style DateView
        dateContainerView.layer.cornerRadius = dateContainerView.frame.height / 6
        dateContainerView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        dateContainerView.layer.borderWidth = 1
        dateLabel.text = "Sun June 13, 2021"
        
        //Style Statactics View
        stataticsView.layer.cornerRadius = stataticsView.frame.height / 10
        stataticsView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        stataticsView.layer.borderWidth = 1
        
        //Set progressbar properties
        circularProgressBar.trackColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        circularProgressBar.progressColor = #colorLiteral(red: 0, green: 0.7097216845, blue: 0.6863465309, alpha: 1)
        circularProgressBar.setProgressWithAnimation(duration: 1.0, value: 0.5)
        
    }
    
    func dataFromHomeViewContoller() {

        activityNameTextField.text = activityName
        
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
    
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    
    }
    
}
