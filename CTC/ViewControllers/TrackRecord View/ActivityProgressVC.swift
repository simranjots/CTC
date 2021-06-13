import UIKit

class ActivityProgressVC: UIViewController {

    var userObject: User!
    var userPracticesData : UserPracticesData!
    var currentUser: CurrentUser!
    var userPractices: UserPractices!
    var valueArray: [PracticeData]?
    var practice : Practice!
    var practiceName : String!
    
    
    @IBOutlet var activityTrackingTableView: UITableView!
    @IBOutlet var tableViewHeader: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentUser = CurrentUser()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        practice = userPractices.getPractices(practiceName: practiceName, user: userObject)
        valueArray = userPracticesData.getPracticebyName(practice: practice.practice!)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Set properties of tableView Header
        tableViewHeader.layer.cornerRadius = tableViewHeader.frame.height / 5
    }
    
    
    

}
extension ActivityProgressVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityProgressCell
        let date = valueArray![indexPath.row].date! as Date
    
        cell.activityDateLabel.text = date.dateFormatemmmdd()
        cell.activityNotesTextView.text = valueArray![indexPath.row].note
        if valueArray![indexPath.row].practised == true {
            cell.practicedDaysLabel.text = "Yes"
        }else{
            cell.practicedDaysLabel.text = "No"
        }
        

        return cell
    }
    
}
