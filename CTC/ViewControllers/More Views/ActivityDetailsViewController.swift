import UIKit

class ActivityDetailsViewController: UIViewController, UIPickerViewDelegate {

    
    
    var dbHelper: DatabaseHelper!
    var userPracticesData: UserPracticesData!
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
    
   
    @IBOutlet var activityNameTextField: UITextField!
    @IBOutlet var stataticsView: UIView!
    @IBOutlet var circularProgressBar: StataticsViewProgressBar!
    @IBOutlet var percentageLabel: UILabel!
    @IBOutlet var daysPracticedLabel: UILabel!
    @IBOutlet var daysSinceStartedLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var startButtonOutlet: UIButton!
    @IBOutlet var saveButtonOutlet: UIButton!
    
    var activityName = ""
    
    // var isTableViewVisible = false
     
     var startValue: Double = 0
     var endValue: Double = 70
     var animationDuration: Double = 2.0
     let animationStartDate = Date()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "Activity Details"
        dbHelper = DatabaseHelper()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
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
        practicesData =  userPracticesData.getPracticeDataByDate(date: selectedDate.dateFormate()!)
     
   
       // notesTextView.delegate = self
        
        let date5 = DateComponents(calendar: .current, year: 2019, month: 2, day: 10).date!
        let now = Date()
        _ = now.days(from: date5)

         currentPractice = practicesArray[myIndex]

        activityNameTextField.setUnderLineWithColor(color: UIColor.lightGray, alpha: 0.5)
        
        createPickerView()
        createToolBar()
        self.setData()
        styleElements()
      
    }
  
    func setData() {
        
        let startedDate = ((practicesArray[myIndex].startedday)! as Date).originalFormate()
        let days = Date().days(from: startedDate) + 1
        
        activityNameTextField.text = practicesArray[myIndex].practice
        daysPracticedLabel.text =  "\(practicesArray[myIndex].practiseddays)"
        let practicedDays = Int(practicesArray[myIndex].practiseddays)
        let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
        
        setPercentageAnimation(percentageValue: percentage)
        daysSinceStartedLabel.text = "\(days)"
        
        if(practicesData != nil){
            
            for data in practicesData{
                
                if data.practiceDataToPractice == practicesArray[myIndex]{
                    let temp = data.note
                    notesTextView.text = temp == "" || temp == nil ? "Write Your Notes Here. . . " : temp
                    self.activeButton(flag: data.practised)
                    
                }
                
            }
            
        }
        
    }
    
 
    
    func setPercentageAnimation(percentageValue: Int){
        
        let percentageFloat : Float = Float(percentageValue)
        let percentageInPoint : Float = percentageFloat / 100
     
        percentageLabel.text = "\(percentageValue)%"
        
        //Set progressbar properties
        circularProgressBar.trackColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        circularProgressBar.progressColor = #colorLiteral(red: 0, green: 0.7097216845, blue: 0.6863465309, alpha: 1)
        circularProgressBar.setProgressWithAnimation(duration: 2.0, value: percentageInPoint)
    }
    
    func createPickerView(){
        
        let resolutionPicker = UIPickerView()
        resolutionPicker.delegate = self
        
        resolutionPicker.backgroundColor = .white

        activityNameTextField.inputView = resolutionPicker
        
    }
    
    func createToolBar(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTodayViewController.dismissPickerView))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        activityNameTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissPickerView() {
 
        
        self.setData()

        view.endEditing(true)
    }
    
    
    
    //Style textFields, textView, Button and Views
    func styleElements() {
        
        //Style textfields, textView and imageView
        Utilities.styleTextField(activityNameTextField)
        Utilities.styleTextView(notesTextView)
        
        
        //Style buttons
        Utilities.styleButton(saveButtonOutlet)
        
        
        //Style Statactics View
        stataticsView.layer.cornerRadius = stataticsView.frame.height / 10
        stataticsView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        stataticsView.layer.borderWidth = 1
        
        
        
    }
    
  
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        self.activeButton(flag: !isOn)
    }
    func activeButton(flag: Bool){
        
        isOn = flag
        if(isOn){
            startButtonOutlet.setImage(UIImage(named: "Star-Selected"), for: .normal)
            
        }else{
            
            startButtonOutlet.setImage(UIImage(named: "Star"), for: .normal)
            
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let ispracticed = isOn
        var noteData = notesTextView.text
        if noteData == "Write Your Notes Here. . . "{
            noteData = ""
        }
        
        
        let savingResult = userPracticesData.practicedToday(toggleBtn: ispracticed, practiceObject: currentPractice, currentDate: selectedDate, userObject: userObject!, note: noteData!)
        
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
            if textView.toolbarPlaceholder == "Write Your Notes Here. . . "{
                textView.text = nil
                
            }
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.toolbarPlaceholder = "Write Your Notes Here. . . "
            textView.textColor = UIColor.lightGray
        }
    }
    
}

protocol ReceiveData {
    func passUserObject(user: User)
}
