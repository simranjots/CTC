//
//  AddPracticesViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-11.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class AddPracticesViewController: UIViewController {
    
    @IBOutlet var chooseValuesTextField: UITextField!
    @IBOutlet var choosePracticesTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var wordsOfEncouragementTextView: UITextView!
    @IBOutlet var activityIconImageView: UIImageView!
    @IBOutlet var choosePracticesIconButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    //PickerView instances
    let valuesPickerView = UIPickerView()
    let practicesPickerView = UIPickerView()
    
    //DatePickerView instance
    let datePicker = UIDatePicker()
    
    //Values and Practices options array
    let values: [String] = [
        "AUTHENTICITY", "ACHIEVEMENT", "ADVENTURE", "BEAUTY", "CHALLENGE", "COMFORT", "COURAGE", "CREATIVITY", "CURIOSITY", "EDUCATION", "EMPOWERMENT", "ENVIRONMENT", "FAMILY", "FINANCIAL", "FREEDOM", "FITNESS", "BALANCE", "GRATITUDE", "LOVE", "FRIENDSHIP", "SERVICE", "HEALTH", "HONESTY", "INDEPENDENCE", "INNER PEACE", "INTEGRITY", "INTELLIGENCE",  "INTIMACY", "JOY", "LEADERSHIP", "LEARNING",  "MOTIVATION", "PASSION", "COMPASSION", "CREDIBILITY", "EMPATHY", "HUMOUR", "RECREATION", "PEACE", "PERFORMANCE", "PERSONAL", "GROWTH", "PLAY", "PRODUCTIVITY", "RELIABILITY", "RESPECT", "SECURITY", "SPIRITUALITY", "SUCCESS", "TIME FREEDOM", "VARIETY" ]
    
    let practices: [String] = ["No Sugar", "Reduce Salt", "No Cheese", "Exercise", "Yoga", "Meditation", "No Meat", "No Alcohol", "Dieting", "No Outside Food", "Fruits & Vegetables"]
    
    let moreOptionIconList = ["Book", "Cheese", "Dollar","Excercise","Flour","Friend Circle","Language","Meditation","Music","Salad","Sleep","SpaCandle","Speak","Walking","WineGlass","Yoga", "Friendship"]
    
    var imageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleElements()
        setPickerViewsPropertiesDelegatesAndDataSources()
    }
    
    @IBAction func choosePracticesIconButtonTapped(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "Resolution Icons", message: "Choose an Icon to Categories Your Resolution", preferredStyle: .actionSheet)
        for icon in moreOptionIconList{
            let image = UIImage(named: icon)
            
            let action = UIAlertAction(title: icon, style: .default){action in self.changeResolutionIcon(imageName: icon)}
            action.setValue(image, forKey: "image")
            actionSheet.addAction(action)
            
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        present(actionSheet,animated: true)
    }
    
    func changeResolutionIcon(imageName: String){
        
        self.imageName = imageName
        activityIconImageView.image = UIImage(named: imageName)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
    }
    
}

//MARK: - Extension for elements stylling and PickerViews setup

extension AddPracticesViewController {
    
    //Style textFields, textView, imageView and buttons
    func styleElements() {
        
        //Style textfields, textView and imageView
        Utilities.styleTextField(chooseValuesTextField)
        Utilities.styleTextField(choosePracticesTextField)
        Utilities.styleTextField(dateTextField)
        Utilities.styleTextView(wordsOfEncouragementTextView)
        Utilities.styleImageView(activityIconImageView)
        
        //Style buttons
        Utilities.styleButton(saveButton)
        Utilities.styleButton(choosePracticesIconButton)
        Utilities.styleHollowButton(cancelButton)
        
        //Add textfield's leftside icons
        guard let valuesIcon = UIImage(named: "values") else { return }
        guard let practicesIcon = UIImage(named: "practice") else { return }
        guard let dateIcon = UIImage(named: "calender") else { return }
        Utilities.addTextFieldImage(textField: chooseValuesTextField, andImage: valuesIcon)
        Utilities.addTextFieldImage(textField: choosePracticesTextField, andImage: practicesIcon)
        Utilities.addTextFieldImage(textField: dateTextField, andImage: dateIcon)
    }
    
    //Set pickerView datasources, delegates and inputViews
    func setPickerViewsPropertiesDelegatesAndDataSources() {
        
        //==============PickerViews' datasource, delegates and inputViews============//
        
        //Set delegate and datasource
        valuesPickerView.dataSource = self
        valuesPickerView.delegate = self
        practicesPickerView.dataSource = self
        practicesPickerView.delegate = self
        
        //Set inputViews
        chooseValuesTextField.inputView = valuesPickerView
        choosePracticesTextField.inputView = practicesPickerView
        
        //Set the tags
        valuesPickerView.tag = 1
        practicesPickerView.tag = 2
        
        //=================DatePickerView inputView and toolbar=====================//
        
        //Toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Toobar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        
        //Assign toolbar and datepicker
        dateTextField.inputAccessoryView = toolBar
        dateTextField.inputView = datePicker
        
        datePicker.datePickerMode = .date
        
    }
    
    @objc func donePressed() {
        
        //Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        //Assign formatted date to textField
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}


//MARK:- UIPickerView extension

extension AddPracticesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            return values.count
            
        case 2:
            return practices.count
            
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return values[row]
            
        case 2:
            return practices[row]
            
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            chooseValuesTextField.text = values[row]
            chooseValuesTextField.resignFirstResponder()
            
        case 2:
            choosePracticesTextField.text = practices[row]
            choosePracticesTextField.resignFirstResponder()
            
        default:
            print("Data not found.")
        }
    }
}
