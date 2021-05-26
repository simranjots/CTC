//
//  HomeTableViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-18.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var practiceTextLabel: UILabel!
    @IBOutlet weak var practiceIconImage: UIImageView!
    
    @IBOutlet weak var yesNoSwitch: UISwitch!
    
    @IBOutlet weak var starButton: UIButton!
    
    
    
    
    // variables
    
    var dbHelper: DatabaseHelper!
    var resultFlag: Int!
    var practice: Practice!
    var selectedDate: Date!
    var view: UIView!
    var isOn: Bool = false
    
    //// variables
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let switchButton = UIButton(type: .custom)
//        switchButton.isSelected = true
//        switchButton.setImage(UIImage(named: "on-switch"), for: .selected)
//        switchButton.setImage(UIImage(named: "off-switch"), for: .normal)
//
        self.backgroundColor = UIColor.white
        
        dbHelper = DatabaseHelper()
        
      
        
        
//        self.layer.cornerRadius = 15
//        self.layer.borderWidth = 0.4
        
//        self.navigationController!.navigationBar.layer.shadowColor = UIColor.black.cgColor
//        self.navigationController!.navigationBar.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        self.navigationController!.navigationBar.layer.shadowRadius = 4.0
//        self.navigationController!.navigationBar.layer.shadowOpacity = 1.0
        
//            self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowRadius = 5
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
//        self.layer.shadowOpacity = 1.0
//
        
        
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func yesNoSwitchTapped(_ sender: Any) {
        
        if(yesNoSwitch.isOn == true){

//            yesNoSwitch.tintColor = .green
//            print("print from cell-------------------------------")
//            print(practice)
//
            resultFlag = dbHelper.addPracticeData(practised: true, practice: practice, date: selectedDate)
            

        }
        else {
//            print("print from cell-------------------------------")
//            print(practice)
             resultFlag = dbHelper.addPracticeData(practised: false, practice: practice, date: selectedDate)
            
//            yesNoSwitch.tintColor = .red
            yesNoSwitch.tintColor = UIColor.red
            yesNoSwitch.layer.cornerRadius = yesNoSwitch.frame.height / 2
            yesNoSwitch.backgroundColor = UIColor.red
//            yesNoSwitch.setImage(UIImage(named: "on-switch"), forState: .Selected)
//            yesNoSwitch.setImage(UIImage(named: "off-switch"), forState: .Normal)
//            yesNoSwitch.offImage = UIImage(named: "Home")

        }
        
        if resultFlag == 0{
            
//            showToast(message: "Data Saved", duration: 3,view: view)
            print("Data Saved")
            
        }else if resultFlag == 1{
            print("error in Cell Data Saving")
//            showAlert(title: "Error", message: "Data saving error please try againm", buttonTitle: "Try Again")
            
        }
        
    }
    
    
    
    @IBAction func starButtonTapped(_ sender: Any) {
        
        self.activeButton(flag: !isOn)
         resultFlag = dbHelper.addPracticeData(practised: isOn, practice: practice, date: selectedDate)
        if resultFlag == 0{
            
            //            showToast(message: "Data Saved", duration: 3,view: view)
            print("Data Saved")
            
        }else if resultFlag == 1{
            print("error in Cell Data Saving")
            //            showAlert(title: "Error", message: "Data saving error please try againm", buttonTitle: "Try Again")
            
        }

    }
    
    func activeButton(flag: Bool){
        
        isOn = flag
        if(isOn){
            starButton.setImage(UIImage(named: "Star-Selected"), for: .normal)
         
        }else{
            
            starButton.setImage(UIImage(named: "Star"), for: .normal)
         
        }
    }
    
    
}
