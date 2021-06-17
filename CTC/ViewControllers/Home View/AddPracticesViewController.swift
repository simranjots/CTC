import UIKit

class AddPracticesViewController: UIViewController {
    
    @IBOutlet var chooseValuesTextField: UITextField!
    @IBOutlet var choosePracticesTextField: UITextField!
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
    var homeViewController = HomeViewController()
    var practicesData: [PracticeData]!
    let date = Date()
    static var cvalue : String = ""
    static var cindexPath : Int = 0
    static var uiSwitchState = false
    
    //PickerView instances
    let valuesPickerView = UIPickerView()
    let practicesPickerView = UIPickerView()
    let goalPickerView = UIPickerView()

    
    //Values and Practices options array
    let values: [String] = [
        "AUTHENTICITY", "ACHIEVEMENT", "ADVENTURE", "BEAUTY", "CHALLENGE", "COMFORT", "COURAGE", "CREATIVITY", "CURIOSITY", "EDUCATION", "EMPOWERMENT", "ENVIRONMENT", "FAMILY", "FINANCIAL", "FREEDOM", "FITNESS", "BALANCE", "GRATITUDE", "LOVE", "FRIENDSHIP", "SERVICE", "HEALTH", "HONESTY", "INDEPENDENCE", "INNER PEACE", "INTEGRITY", "INTELLIGENCE",  "INTIMACY", "JOY", "LEADERSHIP", "LEARNING",  "MOTIVATION", "PASSION", "COMPASSION", "CREDIBILITY", "EMPATHY", "HUMOUR", "RECREATION", "PEACE", "PERFORMANCE", "PERSONAL", "GROWTH", "PLAY", "PRODUCTIVITY", "RELIABILITY", "RESPECT", "SECURITY", "SPIRITUALITY", "SUCCESS", "TIME FREEDOM", "VARIETY" ]
    
    let practices: [String] = ["No Sugar", "Reduce Salt", "No Cheese", "Exercise", "Yoga", "Meditation", "No Meat", "No Alcohol", "Dieting", "No Outside Food", "Fruits & Vegetables"]
    let goals: [String] = ["Forever", "7 Days", "10 Days", "14 Days", "21 Days", "30 Days", "60 Days", "100 Days", "150 Days", "201 Days", "356 Days"]
    
    let moreOptionIconList = ["Book", "Cheese", "Dollar","Excercise","Flour","Friend Circle","Language","Meditation","Music","Salad","Sleep","SpaCandle","Speak","Walking","WineGlass","Yoga", "Friendship"]
    
    var imageName: String = ""
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView.isHidden = true
        dateTextField.text = date.dateFormatemmmdd()
        userPractices = UserPractices()
        currentUser = CurrentUser()
        userPracticesData = UserPracticesData()
        userObject = currentUser.checkLoggedIn()
        selectedDate = Date().dateFormate()!
        practi = self.getPractices()
        practicesData = self.getPracticesData(date: selectedDate)
        
        setData(AddPracticesViewController.cvalue, AddPracticesViewController.cindexPath)
        
        styleElements()
        setPickerViewsPropertiesDelegatesAndDataSources()
        //MARK: Popup Date Picker
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(self.PopUpDatePickerValueChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePickerView
        datePickerView.maximumDate = Date()
        
       //MARK: Custome Done Tool bar
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

@objc func PopUpDatePickerValueChanged(datePicker: UIDatePicker){
    
    dateTextField.text = datePicker.date.dateFormatemmmdd()!
    
}
    

    
    @IBAction func changeTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func reminderTapped(_ sender: UISwitch) {
        if uiSwitch.isOn{
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Reminder") as! ReminderViewController
            AddPracticesViewController.cvalue = "add"
            self.present(vc, animated: true, completion: nil)
        }
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
        
        let practiceName = choosePracticesTextField.text
        let valueName = chooseValuesTextField.text
        let image_Name = imageName
        if (practiceName == ""){
            
            showToast(message: "Please Enter Your Practice", duration: 3)
            
        }
        else if(image_Name == ""){
            
            showToast(message: "Please Select Icon For Practice", duration: 3)
            
        }
        else if(dateTextField.text == ""){
            showToast(message: "Please Select Practice Starting Date", duration: 3)
        }else if(chooseValuesTextField.text == ""){
            showToast(message: "Please Enter Your Values", duration: 3)
        }
        else{
            var practiceFlag: Int!
            if(isUpdating){
                practiceFlag = userPractices.updatePractice(oldPractice: oldPractice!, newPractice: practiceName!, image_name: image_Name, date: datePickerView.date.dateFormate()!, user: userObject,value : valueName!)
                isUpdating = false}
            else{
                practiceFlag = userPractices.addPractices(practice: practiceName!, image_name: image_Name, date: datePickerView.date.dateFormate()!, user: userObject,value : valueName!)
                isUpdating = false
            }
            
            
            if(practiceFlag == 1){
                
                showAlert(title: "Warning", message: "Practice Already Exist. . . ", buttonTitle: "Try Again")
                
            }
            else if(practiceFlag == 2){
                
                showAlert(title: "Error", message: "Please Report an Error . . .", buttonTitle: "Try Again")
                
            }else if (practiceFlag == 0 ){
                self.chooseValuesTextField.text = ""
                self.choosePracticesTextField.text = ""
                self.imageName = ""
                self.datePickerView.date = Date()
                self.activityIconImageView.image = UIImage(named: "Image-gallery")
                let storyboard = UIStoryboard(name: "TabVC", bundle: nil)
                let home = storyboard.instantiateViewController(withIdentifier: "MainTabbedBar")
                present(home, animated: true)
            }
            
        }
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
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
     oldPractice = self.practi[indexPath].practice
     
    activityIconImageView.image = UIImage(named: self.practi[ indexPath].image_name!)
     
      imageName = self.practi[indexPath].image_name!
     
     datePickerView.date = (self.practi[indexPath].startedday)! as Date
     
    dateTextField.text = ((self.practi[indexPath].startedday)! as Date).dateFormatemmmdd()
    // titleLabel.text = "Edit Practice"
    saveButton.setTitle("Confirm", for: .normal)
     isUpdating = true
 }
    
}

//MARK: - Extension for elements stylling and PickerViews setup

extension AddPracticesViewController {
    
    //Style textFields, textView, imageView and buttons
    func styleElements() {

        Utilities.styleTextField(wordsOfEncouragementTextField)
        
        //Style buttons
        Utilities.styleButton(saveButton)
        Utilities.styleButton(choosePracticesIconButton)
        Utilities.styleHollowButton(cancelButton)
        changeButton.layer.cornerRadius = 8.0
        changeButton.layer.borderWidth = 0.5
        
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
