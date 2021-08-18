import UIKit

class PracticesRecordListVC: UIViewController {
    
    @IBOutlet var stataticsVCTableView: UITableView!
    var userPracticesData: UserPracticesData!
    var currentUser : CurrentUser!
    var userObject: User!
    var userPractices: UserPractices!
    var selectedDate: Date!
    var practicesArray: [Practice]!
    var currentPractice : Practice!
    var practicesData: [PracticeData]!
    var percentage: Int = 0
    var myIndex: Int!
    let dbHelper = DatabaseHelper()
    var db = FirebaseDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentUser = CurrentUser()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        userObject = currentUser.checkLoggedIn()
        selectedDate = Date().dateFormate()!
        practicesArray = userPractices.getPractices(user: userObject)!
        practicesData =  userPracticesData.getPracticeData(user: userObject)
        reloadPractices()
    }
    override func viewDidAppear(_ animated: Bool) {
        reloadPractices()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadPractices() {
        stataticsVCTableView.reloadData()
    }

    
}
extension PracticesRecordListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return practicesArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "activity", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ActivityProgressVC
        
        destination.userObject = userObject
        destination.practice = practicesArray[myIndex]
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.practicesRecordListCell, for: indexPath) as! PracticesListCell
        
        let startedDate = ((practicesArray[indexPath.row].startedday)! as Date).originalFormate()
        let days = Date().days(from: startedDate) + 1
        let practicedDays = userPracticesData.getTrackingDay(practice: practicesArray[indexPath.row], date: Date().dateFormate()!)
        percentage = Int((Float(practicedDays!) / Float(days)) * 100)
        if let  monthdata = dbHelper.getMonthid(uid: practicesArray[indexPath.row].uId!){
            cell.activityPracticedForThisMonthLabel.text = "\(monthdata)"
            
        }
        
        cell.activityHeaderTitleLabel.text = practicesArray[indexPath.row].practice
        cell.howManyDaysActivityPracticedLabel.text = "\(practicedDays!)"
        cell.tagLineLabel.text = "Since " + startedDate.dateFormatemmmdd()!
        cell.daysSinceStartedLabel.text = "\(days)"
        
        let practiceData = userPracticesData.getStreak(practice: practicesArray[indexPath.row])
        if practiceData != 0 {
            cell.streakLabel.text = "\(practiceData)"
        }else{
            cell.streakLabel.text = "\(0)"
        }
       
        cell.setPercentageAnimation(percentageValue: percentage)
        if practicedDays ?? 0 > 1 {
            cell.daysLabelTitle.text = "Days"
        }else{
            cell.daysLabelTitle.text = "Day"
        }
        if days > 1 {
            cell.starteddayLabel.text = "Days"
        }else{
            cell.starteddayLabel.text = "Day"
        }
        if practicedDays ?? 0 > 1 {
            cell.monthdaylabel.text = "Days"
        }else{
            cell.monthdaylabel.text = "Day"
        }
        if practiceData > 1 {
            cell.streakdaylabel.text = "Days"
        }else{
            cell.streakdaylabel.text = "Day"
        }
        cell.daysSinceStartedLabelTitle.text = "Since Started"
        cell.thisMonthLabelTitle.text = "This Month"
        cell.streakLabelTitle.text = "Streak"
        
        
        return cell
    }
    
    
    
}
