import UIKit

class ActivityDetailsViewController: UIViewController {
    
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
        self.title =  "\(selectedPractice?.practice ?? "Activity Details")"
        dbHelper = DatabaseHelper()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        practicesArray = userPractices.getPractices(user: userObject)!
        startpracticesData = self.getPracticesData(uid: (selectedPractice?.uId!)!)
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
    private func getPracticesData(uid: String) -> [PracticeData]? {
        return userPracticesData.getPracticeDataByUid(uid: uid)
    }
    override func viewWillAppear(_ animated: Bool) {
        dbHelper = DatabaseHelper()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        practicesArray = userPractices.getPractices(user: userObject)!
        startpracticesData = self.getPracticesData(uid: (selectedPractice?.uId!)!)
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
        Utilities.addShadowAndBorderToView(stataticsView)
        stataticsView.layer.cornerRadius = stataticsView.frame.height / 20
        stataticsView.layer.shadowRadius = 0
        stataticsView.layer.shadowOffset = CGSize(width: 0, height: 1)
        if #available(iOS 13.0, *) {
            stataticsView.layer.backgroundColor = UIColor.systemBackground.cgColor
        } else {
            stataticsView.layer.backgroundColor = UIColor.white.cgColor
        }
        notesTextView.returnKeyType = .done
        notesTextView.delegate = self
        
        //Style buttons
        Utilities.styleHollowButton(saveButtonOutlet)
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let ispracticed = starButton
        var noteData = notesTextView.text
        if noteData == "Write Your Notes Here. . . "{
            noteData = "No note created."
        }
        
        
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
