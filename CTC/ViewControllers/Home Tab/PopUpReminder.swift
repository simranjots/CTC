
import UIKit
protocol PopUpProtocol {
    func handleAction(action: Bool)
}
class PopUpReminder: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var hour: UITextField!
    @IBOutlet weak var minute: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var delegate: PopUpProtocol?
    var RemindDaysLabel = "Everyday"
    static var selectPractice : Practice?
    static var myindex : Int = 0
    static var value = ""
    var reminder = [Reminder]()
    var practiceReminder : PracticeReminder!
    typealias completion = (Bool)->Void
    static var searchCompletion:completion!
    let ReminderPickerView = UIPickerView()
    var weekdays = ["Everyday", "Weekdays", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let hours: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10","11","12","13", "14", "15", "16", "17", "18", "19", "20", "21", "22","23"]
    let weekDict = ["Sunday" : 1, "Monday" : 2, "Tuesday" : 3, "Wednesday" : 4, "thursday" : 5, "Friday" : 6, "Saturday" : 7]
    let minutes: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10","11","12","13", "14", "15", "16", "17", "18", "19", "20", "21", "22","23","24","25", "26", "27", "28", "29", "30", "31", "32", "33", "34","35","36","37", "38", "39", "40", "41", "42", "43", "44", "45", "46","47","48","49", "50", "51", "52", "53", "54", "55", "56", "57", "58","59","60"]
    static var labels = " "
    static var hourlabel :Int16 = 0
    static var minutelabel :Int16 = 0
    let toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        practiceReminder = PracticeReminder()
        reminder = practiceReminder.loadReminderbyPracticeName(uid: (PopUpReminder.selectPractice?.uId)!)
        toolBar.sizeToFit()
        //Toobar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: #selector(savePressed))
        toolBar.setItems([doneButton], animated: true)
        
        ReminderPickerView.dataSource = self
        ReminderPickerView.delegate = self
        
        ReminderPickerView.delegate?.pickerView?(ReminderPickerView, didSelectRow: 0, inComponent: 0)
        ReminderPickerView.delegate?.pickerView?(ReminderPickerView, didSelectRow: 0, inComponent: 1)
        ReminderPickerView.delegate?.pickerView?(ReminderPickerView, didSelectRow: 0, inComponent: 2)
        if PopUpReminder.value == "add"{
            add()
        }
        if PopUpReminder.value == "update"{
            upDate()
        }
        label.inputView = ReminderPickerView
        hour.inputView = ReminderPickerView
        minute.inputView = ReminderPickerView
        label.inputAccessoryView = toolBar
        hour.inputAccessoryView = toolBar
        minute.inputAccessoryView = toolBar
    }
    @IBAction func saveButton(_ sender: Any) {
        
        if PopUpReminder.value == "add"{
            let identifier = (PopUpReminder.selectPractice?.practice)!+label.text!+hour.text!+minute.text!
            let identify = practiceReminder.checkIdentifier(identifier: identifier)
            if reminder.first?.identifier != nil {
                    if identify == false {
                        showToast(message: "This Reminder already exits", duration: 1, height: 30)
                        
                    }else{
                        self.practiceReminder.AddReminder(uid: (PopUpReminder.selectPractice?.uId)!, daysLabel: label.text!, hour: Int16(hour.text!)!, minute: Int16(minute.text!)!, practiceName: (PopUpReminder.selectPractice?.practice)!, identifier: identifier)
                        self.dismiss(animated: true, completion: nil)
                        PopUpReminder.searchCompletion(true)
                    }
                
            }else{
                self.practiceReminder.AddReminder(uid: (PopUpReminder.selectPractice?.uId)!, daysLabel: label.text!, hour: Int16(hour.text!)!, minute: Int16(minute.text!)!, practiceName: (PopUpReminder.selectPractice?.practice)!, identifier: identifier)
                
                self.dismiss(animated: true, completion: nil)
                PopUpReminder.searchCompletion(true)
            }
            
        }
        if PopUpReminder.value == "update"{
            practiceReminder.UpdateReminder(uid: (PopUpReminder.selectPractice?.uId)!, daysLabel: label.text!, hour: Int16(hour.text!)!, minute: Int16(minute.text!)!, practiceName: (PopUpReminder.selectPractice?.practice)!, identifier: reminder[PopUpReminder.myindex].identifier!)
           
            self.dismiss(animated: true, completion: nil)
            PopUpReminder.searchCompletion(true)
        }
       
        
        
    }
    func add()  {
        let date = NSDate()
        let calendar = NSCalendar.current
        let currenthours = calendar.component(.hour, from: date as Date)
        let currentminutes = calendar.component(.minute, from: date as Date)
        label.text = RemindDaysLabel
        hour.text = "\(currenthours)"
        minute.text = "\(currentminutes)"
        
    }
    
    func upDate() {
        label.text = PopUpReminder.labels
        hour.text = "\(PopUpReminder.hourlabel)"
        minute.text = "\(PopUpReminder.minutelabel)"
        
    }
    
    func setupView()  {
        
        //adding an overlay to the view to give focus to the dialog box
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        
        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 10
        popUpView.layer.borderWidth = 1
        popUpView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        popUpView.layer.shadowColor = UIColor.darkGray.cgColor
        popUpView.layer.shadowOffset = CGSize(width: 0, height: 0)
        popUpView.layer.shadowRadius = 10
        popUpView.layer.shadowOpacity = 1
        
        //Styling add and cancel button
        Utilities.styleButton(addButton)
        Utilities.styleHollowButton(cancelButton)
        
        //Styling textFields
        Utilities.styleTextField(label)
        Utilities.styleTextField(hour)
        Utilities.styleTextField(minute)
        
        
    }
    
    @IBAction func cancelbutton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func savePressed() {
        self.view.endEditing(true)
    }
    
    //MARK:- functions for the viewController
    func showPopup(parentVC: UIViewController){
        //creating a reference for the dialogView controller
        if let popupViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "PopUpActionViewController") as? PopUpReminder {
            popupViewController.modalPresentationStyle = .custom
            popupViewController.modalTransitionStyle = .crossDissolve
            
            //setting the delegate of the dialog box to the parent viewController
            popupViewController.delegate = parentVC as? PopUpProtocol
            //presenting the pop up viewController from the parent viewController
            parentVC.present(popupViewController, animated: true)
        }
    }
    
}
extension PopUpReminder: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return weekdays.count
        }
        else if component == 1 {
            return hours.count
        }else if component == 2{
            return minutes.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            return weekdays[row]
        }
        else if component == 1 {
            
            return hours[row]
            
        }else if component == 2{
            
            return minutes[row]
        }
        return " "
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        label.text = weekdays[ReminderPickerView.selectedRow(inComponent: 0)]
        hour.text = hours[ReminderPickerView.selectedRow(inComponent: 1)]
        minute.text = minutes[ReminderPickerView.selectedRow(inComponent: 2)]
    }
    
}

