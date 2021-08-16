import UIKit

class ActivityDetailsViewController: UIViewController,UIAdaptivePresentationControllerDelegate {
    
    var dbHelper: DatabaseHelper!
    var userPracticesData : UserPracticesData!
    var userObject: User!
    var userPractices: UserPractices!
    var selectedDate: Date?
    var practicesArray: [Practice]!
    var practicesData: PracticeData?
    var startpracticesData: [PracticeData]!
    var delegate: ReceiveData?
    var starButton : Bool = false
    var selectedPractice : Practice?
    var check : Bool = false
    let db = FirebaseDataManager()
    let remindPractices = PracticeReminder()

    @IBOutlet weak var uiSwitch: UISwitch!
    @IBOutlet weak var remindInfoBtn: UIButton!
    @IBOutlet weak var startedday: UILabel!
    @IBOutlet weak var practicedays: UILabel!
    @IBOutlet var stataticsView: UIView!
    @IBOutlet var circularProgressBar: StataticsViewProgressBar!
    @IBOutlet var percentageLabel: UILabel!
    @IBOutlet var daysPracticedLabel: UILabel!
    @IBOutlet var daysSinceStartedLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var startButtonOutlet: UIButton!
    @IBOutlet var saveButtonOutlet: UIButton!
    
    
    var startValue: Double = 0
    var endValue: Double = 70
    var animationDuration: Double = 2.0
    let animationStartDate = Date()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.instance.requestAuthorization()
        self.title =  "\(selectedPractice?.practice ?? "Activity Details")"
        dbHelper = DatabaseHelper()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        if remindPractices.loadReminderbyPracticeNameonly(uid: (selectedPractice?.uId)! ) != nil {
            uiSwitch.setOn(selectedPractice!.remindswitch, animated: true)
            if selectedPractice?.remindswitch == true {
                remindInfoBtn.isHidden = false
            }else{
                remindInfoBtn.isHidden = true
            }
        }else{
            remindInfoBtn.isHidden = true
           
        }
        
       
        
        practicesArray = userPractices.getPractices(user: userObject)!
        startpracticesData = self.getPracticesData(date: selectedDate!)
        if(startpracticesData != nil){
            for data in startpracticesData!{
                if data.pUid == selectedPractice?.uId{
                    practicesData = data
                    starButton = data.practised
                }
            }
        }
        self.setData()
        styleElements()
    
    }
    private func getPracticesData(date: Date) -> [PracticeData]? {
        return userPracticesData.getPracticeDataByDate(date: date.dateFormate()!)
    }
    override func viewWillAppear(_ animated: Bool) {
        dbHelper = DatabaseHelper()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        practicesArray = userPractices.getPractices(user: userObject)!
        startpracticesData = self.getPracticesData(date: selectedDate!)
        if(startpracticesData != nil){
            for data in startpracticesData!{
                if data.pUid == selectedPractice?.uId{
                    practicesData = data
                      starButton = data.practised
                }
            }
        }
        setData()
        styleElements()
    }
    
    func setData() {
        let startedDate = ((selectedPractice!.startedday)! as Date).originalFormate()
        practicesData =  userPracticesData.getPracticeDataObj(practiceUid: (selectedPractice?.uId)!)
        let days = Date().days(from: startedDate) + 1
        let practicedDays = practicesData?.tracking_days ?? 0
        daysPracticedLabel.text =  "\(practicedDays)"
        daysSinceStartedLabel.text = "\(days)"
        if days > 1 {
            startedday.text = "Days"
        }else{
            startedday.text = "Day"
        }
        if practicedDays > 1 {
            practicedays.text = "Days"
        }else{
            practicedays.text = "Day"
        }
        let percentage = Int((Float(practicedDays) / Float(days)) * 100)
        setPercentageAnimation(percentageValue: Int(percentage))
        
        if practicesData != nil {
            if practicesData!.practiceDataToPractice == selectedPractice{
            
                let temp = practicesData!.pNotes
                notesTextView.text = temp == "No note created." || temp == nil ? "Write Your Notes Here. . . " : temp
               
                self.activeButton(flag: starButton )
                
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
    
    //Style textFields, textView, Button
    func styleElements() {
        
        Utilities.styleTextView(notesTextView)
  
        
        if #available(iOS 13.0, *) {
            stataticsView.layer.backgroundColor = UIColor.systemBackground.cgColor
        } else {
            stataticsView.layer.backgroundColor = UIColor.white.cgColor
        }
        notesTextView.returnKeyType = .done
        notesTextView.delegate = self
        
        //Style buttons
        startedday.layer.cornerRadius = startedday.frame.height / 4
        
        Utilities.adddayBorderToView(startedday)
        practicedays.layer.cornerRadius = practicedays.frame.height / 4
        Utilities.adddayBorderToView(practicedays)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        self.activeButton(flag: !starButton)
    }
    
    func activeButton(flag: Bool?){
       starButton = flag!
        if (flag!) {
            startButtonOutlet.setImage(UIImage(named: "Star-Selected"), for: .normal)
            check = true
        } else {
            
            startButtonOutlet.setImage(UIImage(named: "Star"), for: .normal)
            check = false
        }
    }
    
    
    @IBAction func remindInfoTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Reminder") as! ReminderViewController
        vc.selectedPractice = selectedPractice
        vc.value = selectedPractice?.user
            ReminderViewController.switchCompletion = {(flag) in
             if(flag){
                self.uiSwitch.setOn(flag, animated: true)
             }else{
                self.uiSwitch.setOn(flag, animated: true)
             }
            }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func remindSwitchTapped(_ sender: Any) {
        let value = UserDefaults.standard.bool(forKey: "Permission")
        if uiSwitch.isOn{
            if  value == true {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Reminder") as! ReminderViewController
                vc.selectedPractice = selectedPractice
                vc.value = selectedPractice?.user
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
    
               show(message: "In order to set remider, please go to the settings and allow notifications permission.", duration: 4)
                uiSwitch.setOn(false, animated: true)
            }
        }else{
            uiSwitch.setOn(false, animated: true)
            remindPractices.RemoveReminder(uid: (selectedPractice?.uId)!)
            
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        save()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        save()
    }
    
    func save() {
        let ispracticed = starButton
        let switchValue = uiSwitch.isOn
        var noteData = notesTextView.text
        if noteData == "Write Your Notes Here. . . "{
            noteData = "No note created."
        }
        userPractices.updateReminderSwitchValue(practice: selectedPractice!, value: switchValue,user: userObject)
        
        let savingResult = userPracticesData.practicedToday(toggleBtn: ispracticed, practiceObject: selectedPractice!, currentDate: selectedDate!, userObject: userObject!, note: noteData!, save: "save", check: check)
        
        if(savingResult == 0){
            
            showToast(message: "Data Saved. . .", duration: 3)
            delegate?.passUserObject(user: userObject)
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeViewController.self) {
                    HomeViewController.practiceAdded(true)
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else if(savingResult == 1){
            showAlert(title: "Error", message: "Datasaving Error Please try again. . .", buttonTitle: "Try Again")
        }
        
    }
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        uiSwitch.setOn(false, animated: true)
    }

        
    }
    
//func saveButtonTapped(_ sender: Any) {
//        let ispracticed = starButton
//        var noteData = notesTextView.text
//        if noteData == "Write Your Notes Here. . . "{
//            noteData = "No note created."
//        }
//
//
//        let savingResult = userPracticesData.practicedToday(toggleBtn: ispracticed, practiceObject: selectedPractice!, currentDate: selectedDate!, userObject: userObject!, note: noteData!, save: "save", check: check)
//
//        if(savingResult == 0){
//
//            showToast(message: "Data Saved. . .", duration: 3)
//            delegate?.passUserObject(user: userObject)
//
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: HomeViewController.self) {
//                    HomeViewController.practiceAdded(true)
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
//        }
//        else if(savingResult == 1){
//            showAlert(title: "Error", message: "Datasaving Error Please try again. . .", buttonTitle: "Try Again")
//        }
//
//    }
//}

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

extension ActivityDetailsViewController : UITextViewDelegate{
    
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write Your Notes Here. . . " {
            textView.text = ""
            textView.textColor = UIColor(named: "Brand Secondary Color")
            textView.font = UIFont(name: "verdana", size: 18.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write Your Notes Here. . . "
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
}

protocol ReceiveData {
    func passUserObject(user: User)
}
