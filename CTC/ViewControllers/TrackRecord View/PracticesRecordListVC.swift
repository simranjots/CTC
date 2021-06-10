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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentUser = CurrentUser()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        userObject = currentUser.checkLoggedIn()
        selectedDate = Date().dateFormate()!
        practicesArray = userPractices.getPractices(user: userObject)!
        practicesData =  userPracticesData.getPracticeDataByDate(date: selectedDate)
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
        destination.practiceName = practicesArray[myIndex].practice
        print("Practice\(String(describing: practicesArray[myIndex].practice))")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.practicesRecordListCell, for: indexPath) as! PracticesListCell
        
        let startedDate = ((practicesArray[indexPath.row].startedday)! as Date).originalFormate()
        let days = Date().days(from: startedDate) + 1
        let practicedDays = Int(practicesArray[indexPath.row].practiseddays)
        percentage = Int((Float(practicedDays) / Float(days)) * 100)
       
        
        cell.activityHeaderTitleLabel.text = practicesArray[indexPath.row].practice
        cell.howManyDaysActivityPracticedLabel.text = "\(practicesArray[indexPath.row].practiseddays)"
        cell.tagLineLabel.text = "Lorem ipsum dolor sit amet."
        
        cell.daysSinceStartedLabel.text = "\(days)"
        cell.activityPracticedForThisMonthLabel.text = "\(practicesArray[indexPath.row].practiseddays)"
        cell.streakLabel.text = "\(practicesArray[indexPath.row].practiseddays)"
        cell.setPercentageAnimation(percentageValue: percentage)
        
        cell.daysLabelTitle.text = "Days"
        cell.daysSinceStartedLabelTitle.text = "Days Since Started"
        cell.thisMonthLabelTitle.text = "This Month"
        cell.streakLabelTitle.text = "Streak"
        
        
        return cell
    }
    
    
    
}