import UIKit

class AddPracticesViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var reminderInfo: UIButton!
    @IBOutlet var chooseValuesTextField: UITextField!
    @IBOutlet var valuesDropDownButtonOutlet: UIButton!
    @IBOutlet var choosePracticesTextField: UITextField!
    @IBOutlet var practicesDropDownButtonOutlet: UIButton!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet weak var wordsOfEncouragementTextField: UITextField!
    @IBOutlet var activityIconImageView: UIImageView!
    @IBOutlet var choosePracticesIconButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var uiSwitch: UISwitch!
    
    var userPractices: UserPractices!
    var userPracticesData: UserPracticesData!
    var currentUser : CurrentUser!
    var selectedDate: Date!
    var isUpdating: Bool! = false
    var oldPractice: String?
    var userObject: User!
    var practi:[Practice]!
    var homeViewController : HomeViewController!
    var practicesData: [PracticeData]!
    let date = Date()
    static var cvalue : String = ""
    static var cindexPath : Int = 0
    static var toggle : Bool =  false
    
    //PickerView instances
    let valuesPickerView = UIPickerView()
    let practicesPickerView = UIPickerView()
    let goalPickerView = UIPickerView()

    //Values and Practices options array
        let values: [String] = [
            "Authenticity", "Achievement", "Adventure", "Beauty", "Challange", "Comfort", "Courage", "Creativity", "Curiosity", "Education", "Empowerment", "Environment", "Family", "Financial", "Freedom", "Fitness", "Balance", "Gratitude", "Love", "Friendship", "Service", "Health", "Honesty", "Independence", "Inner Peace", "Integrity", "Intelligence",  "Intimacy", "Joy", "Leadership", "Learning",  "Motivation", "Passion", "Compassion", "Credibility", "Empathy", "Humour", "Recreation", "Peace", "Performance", "Personal", "Growth", "Play", "Productivity", "Reliability", "Respect", "Security", "Spirituality", "Success", "Time Freedom", "Variaty"]
        
        let practices: [String] = ["Reading", "Writing", "Change Up The Routine", "Skincare Routine", "Coding", "Paint a Picture", "Learn a new Instrument", "Play Music", "PodCasting", "Content Creation", "Take a Course", "Watch a Educational Video", "Sit Down Dinners", "Read to Kids at bedtime", "No Cellphone Until Kids Are Asleep", "Saving Money", "Tracke Spending", "Investing", "Go on Walk", "Go on a Run", "Workout", "Play with Kids", "Write handwritten Note to Someone", "Act of Kindness", "Volunteer", "No Sugar", "Reduce Salt", "No Cheese", "Exercise", "Yoga", "Meditation","No Dairy", "No Meat", "No Alcohol", "Dieting", "No Outside Food", "Fruits & Vegetables", "Read an Article", "Watch an Educational Video", "Work on Project", "Make Someone Laugh", "Watch Funny Video", "Play with Kids", "Play with Dog", "Do a fun Activity", "Journaling", "Ride Bike to Work"]
        
        // "Forever", "7 Days", "10 Days", "14 Days", "21 Days", "30 Days", "60 Days", "100 Days", "150 Days", "201 Days",
        let goals: [String] = ["365 Days"]
        
        let moreOptionIconList = ["Adventure", "Achievement", "Biking", "Building_Trust", "Challange", "Comfort","Change_a_Routine", "Content-Creation", "Dieting", "Education", "Passion", "Family_Dinner", "Financial_Freedom", "Freedom", "Fruits & Vegetables", "Growth", "Hiking", "Investment", "Increase_Productivity", "Intimacy", "Jogging", "Journal_Writing", "Laugh", "Leadership", "No-Outside_Food", "Save_Money", "No-Alcohol", "No-Salt", "No-Sugar", "Painting", "Peace", "Play_with_Kids", "Play_with_Dog", "Podcast", "Recreational_Activity", "Skincare", "Spread_Love", "Respect", "Spread_Happiness", "Study", "Trekking", "Workout", "Writing", "Book", "No-Cheese", "No-Dairy", "Wealth_Management", "Exercise", "Friend Circle","Language","Meditation","Music", "Salad","Sleep","Candle","Speak","Walking","WineGlass","Yoga", "Friendship", "Coding", "No-Cellphone"]
    
    var imageName: String = ""
    
    let wordsOfEncouragementQuotes = ["It is health that is real wealth and not pieces of gold and silver.", "Health is not valued till sickness comes.", "Remain calm, because peace equals power.", "A good laugh and a long sleep are the best cures in the doctor’s book.", "Life is either a daring adventure or nothing.", "Only those who risk going too far can possibly find out how far they can go.", "Good things come to those who sweat.", "The pain you feel today will be the strength you feel tomorrow.", "Do not let the behavior of others destroy your inner peace.", "Nobody can bring you peace but yourself.", "When things change inside you, things change around you.", "More smiling, less worrying.", "The most wasted of all days is one without laughter.", "Meditation is a vital way to purify and quiet the mind, thus rejuvenating the body.", "Your goal is not to battle with the mind, but to witness the mind.", "If you can dream it, You can do it.", "Believe in yourself! Have faith in your abilities! Without a humble but reasonable confidence in your own powers you cannot be successful or happy.", "Press forward. Do not stop, do not linger in your journey, but strive for the mark set before you.", "The future belongs to those who believe in the beauty of their dreams.", "One way to keep momentum going is to have constantly greater goals.", "Never give up, for that is just the place and time that the tide will turn.", "Start where you are. Use what you have. Do what you can."]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderInfo.isHidden = true
        NotificationManager.instance.requestAuthorization()
        uiSwitch.setOn(AddPracticesViewController.toggle, animated: true)
        datePickerView.isHidden = true
        dateTextField.text = date.dateFormatemmmdd()
        userPractices = UserPractices()
        currentUser = CurrentUser()
        userPracticesData = UserPracticesData()
        userObject = currentUser.checkLoggedIn()
        selectedDate = Date().dateFormate()!
        homeViewController = HomeViewController()
        practi = self.getPractices()
        practicesData = self.getPracticesData(date: selectedDate)
        setData(AddPracticesViewController.cvalue, AddPracticesViewController.cindexPath)
        styleElements()
        setPickerViewsPropertiesDelegatesAndDataSources()
        
        //MARK:- Popup Date Picker
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(self.PopUpDatePickerValueChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePickerView
        datePickerView.maximumDate = Date()
        
       //MARK: - Custome Done Tool bar
              let toolBar = UIToolbar()
              toolBar.sizeToFit()
              let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dateSelected))
              toolBar.setItems([doneButton], animated: false)
              toolBar.isUserInteractionEnabled = true
              dateTextField.inputAccessoryView = toolBar
    }
    
    private func getPractices() -> [Practice]{
        return userPractices.getPractices(user: userObject)!
    }
    
    private func getPracticesData(date: Date) -> [PracticeData]?{
        return userPracticesData.getPracticeDataByDate(date: date.dateFormate()!)
    }
    
    @objc func dateSelected() {
        dateTextField.text = datePickerView.date.dateFormatemmmdd()
        self.view.endEditing(true)
    }

    @objc func PopUpDatePickerValueChanged(datePicker: UIDatePicker) {
    dateTextField.text = datePicker.date.dateFormatemmmdd()!
    }
    
    //MARK: - IBActions
    @IBAction func reminderInfoPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Reminder") as! ReminderViewController
            vc.practiceName = choosePracticesTextField.text!
            vc.value = AddPracticesViewController.cvalue
            ReminderViewController.switchCompletion = {(flag) in
             if(flag){
                self.uiSwitch.setOn(flag, animated: true)
             }else{
                self.uiSwitch.setOn(flag, animated: true)
             }
            }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func changeTapped(_ sender: UIButton) {
        let randomNumber = Int.random(in: 1..<wordsOfEncouragementQuotes.count)
        wordsOfEncouragementTextField.text = wordsOfEncouragementQuotes[randomNumber]
    }
    
    @IBAction func reminderTapped(_ sender: UISwitch) {
        let value = UserDefaults.standard.bool(forKey: "Permission")
        if AddPracticesViewController.cvalue == "edit"{
        if uiSwitch.isOn{
            if  value == true {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Reminder") as! ReminderViewController
                vc.practiceName = choosePracticesTextField.text!
                vc.value = AddPracticesViewController.cvalue
                vc.presentationController?.delegate = self
                ReminderViewController.switchCompletion = {(flag) in
                 if(flag){
                    self.uiSwitch.setOn(flag, animated: true)
                 }else{
                    self.uiSwitch.setOn(flag, animated: true)
                 }
                }
            self.present(vc, animated: true, completion: nil)
            }else{
                
               showToast(message: "Please go to the setting and allow Permission for Notification", duration: 3)
                uiSwitch.setOn(false, animated: true)
                _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
                    self.dismiss(animated: true)
                }
            }
        }else{
            uiSwitch.setOn(false, animated: true)
        }
        }else{
            showToast(message: "To set reminder go to edit after adding the Practise", duration: 2)
            uiSwitch.setOn(false, animated: true)
            
        }
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        uiSwitch.setOn(false, animated: true)
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
    
    func validatFields() -> String? {
        
        let practiceName = choosePracticesTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let valueName = chooseValuesTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let encourage = wordsOfEncouragementTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let goal =  goalTextField.text?.trimmingCharacters(in: .whitespaces)
        let image_Name = imageName
        
        if practiceName == "" || valueName == "" || encourage == "" || goal == "" {
           return "Practice or Value or Goal or Words of Encouragement Fiels are blank."
        }
        
        if image_Name == "" {
          return "Please select image icon for practice."
        }
        
        if dateTextField.text == "" {
            return "Please select practice starting date"
        }
        
        if Utilities.isStringValid(valueName) == true {
            return "Value field should not contain any special charactors or numbers."
        }
        
        if Utilities.isStringValid(practiceName) == true {
            return "Practice field should not contain any special charactors or numbers."
        }
        
        if Utilities.isStringContainsAllowedSpecialChar(encourage!) == true {
            return "Words of encouragement should not contain any special charactors exept '.,!?'' or numbers."
        }
        return nil
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let practiceName = choosePracticesTextField.text
        let valueName = chooseValuesTextField.text
        let encourage = wordsOfEncouragementTextField.text
        let switchValue = uiSwitch.isOn
        let goal =  goalTextField.text
        let image_Name = imageName
        
        let error = validatFields()
        
        if error != nil {
            
            showToast(message: error!, duration: 2.0)
        } else {
            var practiceFlag: Int!
            if(isUpdating){
               
                practiceFlag = userPractices.updatePractice(oldPractice: oldPractice!, newPractice: practiceName!, image_name: image_Name, date: datePickerView.date.dateFormate()!, user: userObject,value : valueName!,encourage : encourage!,remindswitch : switchValue, goals: goal!)
                isUpdating = false
                
            }
            else{
                practiceFlag = userPractices.addPractices(practice: practiceName!, image_name: image_Name, date: datePickerView.date.dateFormate()!, user: userObject,value : valueName!,encourage : encourage!,remindswitch : switchValue, goals: goal!)
                isUpdating = false
            }
            
            
            if(practiceFlag == 1){
                
                showAlert(title: "Error", message: "Please Report an Error . . .", buttonTitle: "Try Again")
                
            }
            else if(practiceFlag == 2){
                showAlert(title: "Warning", message: "Practice Already Exist. . . ", buttonTitle: "Try Again")

                
            }else if (practiceFlag == 0 ){
                
                self.chooseValuesTextField.text = ""
                self.choosePracticesTextField.text = ""
                self.imageName = ""
                self.datePickerView.date = Date()
                self.activityIconImageView.image = UIImage(named: "Image-gallery")
                HomeViewController.practiceAdded(true)
                dismiss(animated: true)
            }
            
        }
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        uiSwitch.setOn(false, animated: true)
        self.chooseValuesTextField.text = ""
        self.choosePracticesTextField.text = ""
        self.goalTextField.text = ""
        self.imageName = ""
        self.datePickerView.date = Date()
        self.activityIconImageView.image = UIImage(named: "Iphoto.on.rectangle.angled")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateFieldTapped(_ sender: Any) {
     datePickerView.isHidden = false
    }
    
    @IBAction func valuesDropDownTapped(_ sender: UIButton) {

        let alert = UIAlertController(title: "Enter Value", message: "Enter customized value you want to achieve, if you haven't found in the list.", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter value you want to accomplish."
        }
        
        alert.addAction( UIAlertAction(title: "Add Value", style: .default, handler: { (action) in
            let textField = alert.textFields![0]
            self.chooseValuesTextField.text = textField.text
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func practicesDropDownTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Enter Practice", message: "Enter customized practice you want to implement, if you haven't found in the list.", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter practice you want to implement."
        }
        
        alert.addAction(UIAlertAction(title: "Add Practice", style: .default, handler: { (action) in
            let textField = alert.textFields![0]
            self.choosePracticesTextField.text = textField.text
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func setData(_ value : String,_ indexPath: Int){
     if value == "add" {
         add()
     }
     if value == "edit" {
         update(indexPath: indexPath)
     }
 }

 func add(){
     self.title = "Add Practice"
      reminderInfo.isHidden = true
     self.saveButton.setTitle("Add", for: .normal)
     dateTextField.text = Date().dateFormatemmmdd()
     chooseValuesTextField.text = values.first
     choosePracticesTextField.text = practices.first
     goalTextField.text = goals.first
 }
    
 func update(indexPath :Int) {
    self.title = "Update Practice"
    chooseValuesTextField.text = self.practi[indexPath].values
    choosePracticesTextField.text = self.practi[indexPath].practice
    goalTextField.text = practi[indexPath].goals
     oldPractice = self.practi[indexPath].practice
     
    activityIconImageView.image = UIImage(named: self.practi[ indexPath].image_name!)
     
      imageName = self.practi[indexPath].image_name!
     
     datePickerView.date = (self.practi[indexPath].startedday)! as Date
     
    dateTextField.text = ((self.practi[indexPath].startedday)! as Date).dateFormatemmmdd()
    uiSwitch.setOn(self.practi[indexPath].remindswitch, animated: true)
    if self.practi[indexPath].remindswitch {
        reminderInfo.isHidden = false
    }
    wordsOfEncouragementTextField.text = practi[indexPath].encourage
    // titleLabel.text = "Edit Practice"
    saveButton.setTitle("Confirm", for: .normal)
    dateTextField.isUserInteractionEnabled = false
     isUpdating = true
 }
    
}

//MARK: - Extension for elements stylling and PickerViews setup

extension AddPracticesViewController {
    
    //Style textFields, textView, imageView and buttons
    func styleElements() {

        
        //Style Textfields
        Utilities.addBottomLineToTextField(chooseValuesTextField)
        Utilities.addBottomLineToTextField(choosePracticesTextField)
        Utilities.addBottomLineToTextField(goalTextField)
        Utilities.addBottomLineToTextField(dateTextField)
        Utilities.addBottomLineToTextField(wordsOfEncouragementTextField)
        
        //Style buttons
        Utilities.styleButton(saveButton)
        Utilities.styleButton(choosePracticesIconButton)
        Utilities.styleHollowButton(cancelButton)
        changeButton.layer.cornerRadius = 8.0
        changeButton.layer.borderWidth = 1.0
    }
    
    //Set pickerView datasources, delegates and inputViews
    func setPickerViewsPropertiesDelegatesAndDataSources() {
        
        //==============PickerViews' datasource, delegates and inputViews============//
        
        //Set delegate and datasource
        valuesPickerView.dataSource = self
        valuesPickerView.delegate = self
        practicesPickerView.dataSource = self
        practicesPickerView.delegate = self
        goalPickerView.dataSource = self
        goalPickerView.delegate = self
        
        //Set inputViews
        chooseValuesTextField.inputView = valuesPickerView
        
        choosePracticesTextField.inputView = practicesPickerView
        //valuesDropDownButtonOutlet. = valuesPickerView
        
        goalTextField.inputView = goalPickerView
        
        //Set the tags
        valuesPickerView.tag = 1
        practicesPickerView.tag = 2
        goalPickerView.tag = 3
        
        //=================DatePickerView inputView and toolbar=====================//
        
        //Toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Toobar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        
        //Assign toolbar and datepicker
        dateTextField.inputAccessoryView = toolBar
        chooseValuesTextField.inputAccessoryView = toolBar
        choosePracticesTextField.inputAccessoryView = toolBar
        dateTextField.inputView = datePickerView
        datePickerView.datePickerMode = .date
        
    }
    
    @objc func donePressed() {
        
        //Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        //Assign formatted date to textField
        dateTextField.text = dateFormatter.string(from: datePickerView.date)
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
            
        case 3:
            return goals.count
            
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
            
        case 3:
            return goals[row]
            
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
            
        case 3:
            goalTextField.text = goals[row]
            goalTextField.resignFirstResponder()
            
        default:
            print("Data not found.")
        }
    }
}
