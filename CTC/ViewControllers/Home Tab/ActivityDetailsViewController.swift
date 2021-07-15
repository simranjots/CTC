import UIKit

class ActivityDetailsViewController: UIViewController {
    
    var dbHelper: DatabaseHelper!
    var userPracticesData = UserPracticesData()
    var userObject: User!
    var userPractices: UserPractices!
    var selectedDate: Date!
    var practicesArray: [Practice]!
    var practicesData: PracticeData?
    var delegate: ReceiveData?
    static var isOn : Bool?
    var starButton : Bool?
    var selectedPractice : Practice? 
    @IBOutlet var stataticsView: UIView!
    @IBOutlet var circularProgressBar: StataticsViewProgressBar!
    @IBOutlet var percentageLabel: UILabel!
    @IBOutlet var daysPracticedLabel: UILabel!
    @IBOutlet var daysSinceStartedLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var startButtonOutlet: UIButton!
    @IBOutlet var saveButtonOutlet: UIButton!
    
    var activityName = ""
     
     var startValue: Double = 0
     var endValue: Double = 70
     var animationDuration: Double = 2.0
     let animationStartDate = Date()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "\(selectedPractice?.practice ?? "Activity Details")"
        dbHelper = DatabaseHelper()
        userPractices = UserPractices()
        practicesArray = userPractices.getPractices(user: userObject)!
        self.setData()
        styleElements()
      
    }
  
    func setData() {
        starButton = ActivityDetailsViewController.isOn
        practicesArray = userPractices.getPractices(user: userObject)!
        practicesData =  userPracticesData.getPracticeDataObj(practiceName: selectedPractice!.practice!)
        let startedDate = ((selectedPractice!.startedday)! as Date).originalFormate()
        let days = Date().days(from: startedDate) + 1
        let practicedDays = practicesData?.tracking_days ?? 0
        daysPracticedLabel.text =  "\(practicedDays)"
        daysSinceStartedLabel.text = "\(days)"
        let percentage = Int((Float(practicedDays) / Float(days)) * 100)
        setPercentageAnimation(percentageValue: Int(percentage))
       
            
            if practicesData!.practiceDataToPractice == selectedPractice{
                    
                let temp = practicesData!.note
                    notesTextView.text = temp == "" || temp == nil ? "Write Your Notes Here. . . " : temp
                
                self.activeButton(flag: starButton ?? false)
                    
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
        
        //Style buttons
        Utilities.styleHollowButton(saveButtonOutlet)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
    
        self.activeButton(flag: starButton)
    }
    
    func activeButton(flag: Bool?){
        
        starButton = flag
        if (starButton!) {
            startButtonOutlet.setImage(UIImage(named: "Star-Selected"), for: .normal)
            
        } else {
            
            startButtonOutlet.setImage(UIImage(named: "Star"), for: .normal)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let ispracticed = starButton
        var noteData = notesTextView.text
        if noteData == "Write Your Notes Here. . . "{
            noteData = ""
        }
        
        
        let savingResult = userPracticesData.practicedToday(toggleBtn: ispracticed!, practiceObject: selectedPractice!, currentDate: selectedDate, userObject: userObject!, note: noteData!, save: "save")
        
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
