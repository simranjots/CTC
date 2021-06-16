import UIKit

class ShowRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    //    MARK: Old Variables
    
    
    
    @IBOutlet weak var recordTableView: UITableView!
    
    //MARK: Pop up Outlets
    
    @IBOutlet var mainPopUpView: UIView!
    
    @IBOutlet weak var popUpForegroundView: UIView!
    @IBOutlet weak var popUpTitleLabel: UILabel!
    @IBOutlet weak var popUpDateLabel: UILabel!
    @IBOutlet weak var popUpPracticeTextField: UITextField!
    @IBOutlet weak var popUpPracticedSwitch: UISwitch!
    @IBOutlet weak var popUpNoteTextArea: UITextView!
    @IBOutlet weak var popUpUpdateButton: UIButton!
    @IBOutlet weak var popUpCancelButton: UIButton!
    
    
    // MARK: Variables
    var userObject: User?
    var dbHelper : DatabaseHelper!
    var userPracticesData : UserPracticesData!
    var currentUser: CurrentUser!
    var userPractices: UserPractices!
    var dataDict = [Date: [AnyObject] ]()
    var practices = [Practice]()
    var valueArray: [PracticeData]?
    var dictKeys : [Date]?
    var percentageData = [[String:String?]]()
    var dateIndex: Int!
    var dataIndex: Int!
    var firstDayOfYear : Date! = DateComponents(calendar: .current, year: 2019, month: 1, day: 1).date!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHelper = DatabaseHelper()
        currentUser = CurrentUser()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        userObject = currentUser.checkLoggedIn()
        
        
        // MARK: Popup Setup
        popUpForegroundView.setPopupView()
        popUpCancelButton.setPopUpButton()
        popUpUpdateButton.setPopUpButton()
        popUpTitleLabel.setPopUpTitle()
        
        
        if (userObject != nil){
            
        }
        
        practices = userPractices.getPractices(user: userObject!)!
        dataDict = dbHelper.getPracRecordTemp(user: userObject!)!
    
        for practiceObject in practices{
            let startedDate = ((practiceObject.startedday! as Date).originalFormate())
            let days = Date().days(from: startedDate) + 1
          
            let percentage = Int(Float(practiceObject.practiseddays  * 100) / Float(days))
            percentageData.append(["Practice": practiceObject.practice!, "Percentage": "\(percentage)", "TrackingDay": String(practiceObject.practiseddays), "outOfDays":String(days)])
            
        }
      
        dictKeys = Array(dataDict.keys)
        dictKeys =  dictKeys?.sorted(by: <)
      
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTodayViewController.dismissKeyboard))
//
       // toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        popUpNoteTextArea.inputAccessoryView = toolBar
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.refreshTableView()
    }
    
    func refreshTableView() {
        
        percentageData = [[String:String?]]()
        
        practices = userPractices.getPractices(user: userObject!)!
        dataDict = dbHelper.getPracRecordTemp(user: userObject!)!
    
        for practiceObject in practices{
            let startedDate = ((practiceObject.startedday! as Date).originalFormate())
            let days = Date().days(from: startedDate) + 1
          
            let percentage = Int(Float(practiceObject.practiseddays  * 100) / Float(days))
            percentageData.append(["Practice": practiceObject.practice!, "Percentage": "\(percentage)", "TrackingDay": String(practiceObject.practiseddays), "outOfDays":String(days)])
            
        }
    
        dictKeys = Array(dataDict.keys)
        dictKeys =  dictKeys?.sorted(by: >)
     
        self.recordTableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return DayWiseData.count + 1
        return (dictKeys?.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            return percentageData.count
        }else{
            //            print("Count for key = \(dictKeys![section-1]) and count = \(dataDict[dictKeys![section-1].dateFormateToString()!]!.count)")
            return dataDict[dictKeys![section-1]]!.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let Zerocell = tableView.dequeueReusableCell(withIdentifier: "SectionZeroHederCell")
            Zerocell?.backgroundColor = Theme.secondaryColor
            
            return Zerocell
        }
        else{
            
            let dataOfDict = dataDict[dictKeys![section-1]]![0]
         
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionOneHederCell") as! DataHeaderCell
           
            if let temobj = dataOfDict as? PracticeData {
                
                cell.LabelDate.text = "Date \n\(dictKeys![section-1].dateFormatemmmdd()!)"
                let tempData = (dictKeys![section-1].dateFormateToString()!).stringToDate()
                cell.daysLabel.text = "Practiced\nDays"
               
                cell.backgroundColor = Theme.secondaryColor
                
                
            }else if let temObj = dataOfDict as? WeeklyData {//set date in database helper
                
                
                let startDate = temObj.start_date! as Date
                let endDate = temObj.end_date! as Date
                
                let Zerocell = tableView.dequeueReusableCell(withIdentifier: "SectionZeroHederCell") as! RecordTableSectionZeroTableViewCell
                
                Zerocell.backgroundColor = Theme.secondaryColor
                
                Zerocell.titleLabel.text = "Week From \(startDate.dateFormatemmmdd()!) To \(endDate.dateFormatemmmdd()!)"
                
                return Zerocell
                
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
      
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionZeroDataCell") as! ShowPercentageCell

            let perString = percentageData[indexPath.row]["Percentage"] as? String
            let Percentage = Int((perString ?? "0"))
            cell.PercentageLabel.text = "\(String(describing: Percentage!))%"
            cell.ResolutionTextLabel.text = percentageData[indexPath.row]["Practice"] as? String
            cell.PercentageProgressView.setProgress( Float(Float(Percentage!)/100), animated: true)
            let TrackingDay = percentageData[indexPath.row]["TrackingDay"]
            
            let outofDays = percentageData[indexPath.row]["outOfDays"]
            cell.TrackingDayLabel.text = "Day : \(TrackingDay! ?? "0")/\(outofDays! ?? "0")"
            
            return cell
        }
        
        
        let dataOfDict = dataDict[dictKeys![indexPath.section-1]]![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionOneDataCell") as! DataCell
        
        if let temobj = dataOfDict as? PracticeData {
            
            cell.ResolutionTextLabel.text = temobj.practiceDataToPractice?.practice
            if(temobj.note != nil){
                cell.PersonalNoteTextView.text = temobj.note!
            }else{cell.PersonalNoteTextView.text = ""}
            
            cell.TrackingDayLabel.text = String(temobj.tracking_days)
            
            
        }else if let temObj = dataOfDict as? WeeklyData {//set date in database helper
            
            
            let startDate = temObj.start_date! as Date
            let endDate = temObj.end_date! as Date
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionZeroDataCell") as! ShowPercentageCell
            
            let totalNoofDays = Int(temObj.total_no_of_days)
            let noOfDayPracticed = Int(temObj.no_of_days_practiced)
            let PracticeName: String! = temObj.practice_name
            
            let percentage = ((Float(noOfDayPracticed) / Float(totalNoofDays)))
            
            let perString = String(percentage * 100)
            
            cell.PercentageLabel.text = "\(perString)%"
            
            cell.ResolutionTextLabel.text = PracticeName
            cell.PercentageProgressView.setProgress( percentage, animated: true)
            
            cell.TrackingDayLabel.text = "Day : \(noOfDayPracticed)/\(totalNoofDays)"
            
            return cell
            
        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dateIndex = indexPath.section-1
        dataIndex = indexPath.row
        let tempDataBuffer = dataDict[dictKeys![indexPath.section-1]]![indexPath.row]
        
        
        if let tempObj = tempDataBuffer as? PracticeData{
            popUpDateLabel.text = "Date: \(dictKeys![indexPath.section-1])"
            popUpPracticeTextField.text = tempObj.practiceDataToPractice?.practice
            popUpNoteTextArea.text = tempObj.note
            popUpPracticedSwitch.isOn = tempObj.practised
            
            
            self.view.addSubview(mainPopUpView)
            mainPopUpView.center = self.view.center
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: popUp Events
    
    @IBAction func practicedSwitchTapped(_ sender: Any) {
    }
    @IBAction func popUpdateButtonTapped(_ sender: Any) {
        
        let practiceName = popUpPracticeTextField.text!
        let notes = popUpNoteTextArea.text!
        let practiced = popUpPracticedSwitch.isOn
        let date = (dictKeys![dateIndex])
        
        
        let resultFlag = userPracticesData.updatePracticeData(practiceName: practiceName, practiceDate: date, note: notes, practiced: practiced)
        
        if(resultFlag == 0){
            
            showToast(message: "Data Updated... ", duration: 3)
            
        }else{
            
            showToast(message: "error In Data Updation... ", duration: 3)
            
        }
        self.popUpPracticeTextField.text = ""
        self.popUpNoteTextArea.text = ""
        self.mainPopUpView.removeFromSuperview()
        self.refreshTableView()
        
    }
    @IBAction func popUpCancelButtonTapped(_ sender: Any) {
        
        self.popUpPracticeTextField.text = ""
        self.popUpNoteTextArea.text = ""
        self.mainPopUpView.removeFromSuperview()
        
    }
    
}
