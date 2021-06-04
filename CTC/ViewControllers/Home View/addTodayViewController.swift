import UIKit

class addTodayViewController: UIViewController{
    
   // variables
    
    var dbHelper: DatabaseHelper!
    var userObject: User!
    var userPractices: UserPractices!
    var selectedDate: Date!
    var practicesArray: [Practice]!
    var myIndex: Int!
    var firstDayOfYear : Date! = DateComponents(calendar: .current, year: 2019, month: 1, day: 1).date!
    var currentPractice : Practice!
    var practicesData: [PracticeData]!
    var delegate: ReceiveData?
    var isOn : Bool = false
    
    ////variables
 
    @IBOutlet weak var progressView: CircularProgressView!
    
    
    @IBOutlet weak var percentageLabel: AnimationLabel!
    
    @IBOutlet weak var resolutionTextField: UITextField!
    @IBOutlet weak var resolutionPickerView: UIPickerView!
    
    
    @IBOutlet weak var dayOfYearLabel: UILabel!
    @IBOutlet weak var trackingDayLabel: UILabel!
    @IBOutlet weak var isPracticedSwitch: UISwitch!
    
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var noteBackgroundView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var starButton: UIButton!
    
    var isTableViewVisible = false
    
    var startValue: Double = 0
    var endValue: Double = 70
    var animationDuration: Double = 2.0
    let animationStartDate = Date()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dbHelper = DatabaseHelper()
        userPractices = UserPractices()
        
        self.title = selectedDate.dateFormatemmmdd()!
        
        // getting current yeat
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy"
        // again convert your date to string
        let year = formatter.string(from: yourDate!)
         firstDayOfYear = DateComponents(calendar: .current, year: Int(year), month: 1, day: 1).date!
        
        // getting current year
        
        
        practicesArray = userPractices.getPractices(user: userObject)!
        practicesData =  dbHelper.getPracticeDataByDate(date: selectedDate.dateFormate()!)
     
   
        noteTextView.delegate = self
        
        let date5 = DateComponents(calendar: .current, year: 2019, month: 2, day: 10).date!
        let now = Date()
        _ = now.days(from: date5)

         currentPractice = practicesArray[myIndex]

        resolutionTextField.setUnderLineWithColor(color: UIColor.lightGray, alpha: 0.5)
        
        createPickerView()
        createToolBarForNoteTextArea()
        createToolBar()
        
        saveButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = saveButton.frame.height * 0.3
        saveButton.backgroundColor = Theme.secondaryColor
        
        
        noteBackgroundView.layer.borderWidth = 0.5
        noteBackgroundView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        noteBackgroundView.layer.cornerRadius = 10
        
        
        noteTextView.text = "Write Your Notes Here. . . "
        noteTextView.textColor = UIColor.lightGray
    
        
        self.setData()
    }
    
    func setData() {
        
        let startedDate = ((practicesArray[myIndex].startedday)! as Date).originalFormate()
        let days = Date().days(from: startedDate) + 1
        
        resolutionTextField.text = practicesArray[myIndex].practice
        dayOfYearLabel.text = "\(days)"
        let practicedDays = Int(practicesArray[myIndex].practiseddays)
        let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
        
        setPercentageAnimation(percentageValue: percentage)
        trackingDayLabel.text = "\(practicesArray[myIndex].practiseddays)"
        
        if(practicesData != nil){
            
            for data in practicesData{
                
                if data.practiceDataToPractice == practicesArray[myIndex]{
                    let temp = data.note
                    noteTextView.text = temp == "" || temp == nil ? "Write Your Notes Here. . . " : temp
                    self.activeButton(flag: data.practised)
                    
                }
                
            }
            
        }
        
    }
    
 
    
    func setPercentageAnimation(percentageValue: Int){
        
        let percentageFloat : Float = Float(percentageValue)
        let percentageInPoint : Float = percentageFloat / 100
        
        progressView.trackColor = UIColor.lightGray
        progressView.progressColor = UIColor(displayP3Red: 64/255, green: 224/255, blue: 208/255, alpha: 1)
        progressView.setProgressWithAnimation(duration: 2.0, value: percentageInPoint)
        
        percentageLabel.startAnimation(fromValue: 0, to: percentageFloat, withDuration: 2, andAnimatonType: .Linear, andCounterType: .Int)
        
    }
    
    func createPickerView(){
        
        let resolutionPicker = UIPickerView()
        resolutionPicker.delegate = self
        
        resolutionPicker.backgroundColor = .white

        resolutionTextField.inputView = resolutionPicker
        
    }
    
    func createToolBar(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTodayViewController.dismissPickerView))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        resolutionTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissPickerView() {
 
        
        self.setData()

        view.endEditing(true)
    }
    
    func createToolBarForNoteTextArea(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTodayViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        noteTextView.inputAccessoryView = toolBar
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! HomeViewController
        
        destination.userObject = userObject
        
    }
   
    
    
    // custome Button
    
    func customeButton(button : UIButton){
        
        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "DropDown"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 100, bottom: 6, right: 14)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -36, bottom: 0, right: 34)
        
   
    }
    
    
    func customeSaveButton(button: UIButton){
        
        
        button.layer.cornerRadius = 10
        button.layer.backgroundColor = UIColor.white.cgColor
        button.titleLabel?.textColor = UIColor.white
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        button.layer.shadowOpacity = 1.0
        
        
        
    }
    
    func customizeNoteTitle(label : UILabel){
        
        label.layer.cornerRadius = 10
        label.layer.backgroundColor = UIColor.white.cgColor
//        label.titleLabel?.textColor = UIColor.black
        label.layer.shadowColor = UIColor.darkGray.cgColor
        label.layer.shadowRadius = 4
        label.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        label.layer.shadowOpacity = 1.0
        
    }
    
    func customizetextField(textField : UITextField){
        
        textField.layer.cornerRadius = 10
        textField.layer.backgroundColor = UIColor.white.cgColor
        //        label.titleLabel?.textColor = UIColor.black
        textField.layer.shadowColor = UIColor.darkGray.cgColor
        textField.layer.shadowRadius = 4
        textField.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        textField.layer.shadowOpacity = 1.0
        
    }
    
    
    @IBAction func starButtonTapped(_ sender: Any) {
        
        self.activeButton(flag: !isOn)
        
    }
    
    func activeButton(flag: Bool){
        
        isOn = flag
        if(isOn){
            starButton.setImage(UIImage(named: "Star-Selected"), for: .normal)
            
        }else{
            
            starButton.setImage(UIImage(named: "Star"), for: .normal)
            
        }
    }
   
    @IBAction func saveButtonTappde(_ sender: Any) {
        
        let ispracticed = isOn
        var noteData = noteTextView.text
        if noteData == "Write Your Notes Here. . . "{
            noteData = ""
        }
        
        
        let savingResult = dbHelper.addPracticeData(note: noteData!, practised: ispracticed, practice: currentPractice,date: selectedDate)
        
        if(savingResult == 0){
            
            showToast(message: "Data Saved. . .", duration: 3)
            delegate?.passUserObject(user: userObject)
          
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else if(savingResult == 1){
            showAlert(title: "Error", message: "Datasaving Error Please try again. . .", buttonTitle: "Try Again")
        }
        
    }
    
    
}

extension addTodayViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    // Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return practicesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return practicesArray[row].practice
    }
    
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        myIndex = row
        resolutionTextField.text = "\(String(describing: practicesArray[row].practice!))"
  
    }
    
    // Picker View
    
}
extension UITextField{
    
    
    func setUnderLineWithColor(color: UIColor, alpha : Float){
        
        self.layer.shadowOpacity = alpha
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = color.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 2
        
    }
    
}

extension addTodayViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            if textView.text == "Write Your Notes Here. . . "{
                textView.text = nil
                
            }
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write Your Notes Here. . . "
            textView.textColor = UIColor.lightGray
        }
    }
    
}

protocol ReceiveData {
    func passUserObject(user: User)
}
