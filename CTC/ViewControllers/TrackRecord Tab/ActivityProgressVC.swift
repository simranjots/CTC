import UIKit

class ActivityProgressVC: UIViewController {

    var userObject: User!
    var userPracticesData : UserPracticesData!
    var currentUser: CurrentUser!
    var userPractices: UserPractices!
    var valueArray: PracticeData!
    var practiceNotes : PracticeNotes!
    var NotesArray: [Notes]?{
        didSet {
            activityTrackingTableView.reloadData()
        }
    }
    var practice : Practice!
    var practiceName : String!
    
    @IBOutlet var activityTrackingTableView: UITableView!
    @IBOutlet var tableViewHeader: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentUser = CurrentUser()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        practiceNotes = PracticeNotes()
        practice = userPractices.getPractices(practiceName: practiceName, user: userObject)
        valueArray = userPracticesData.getPracticeDataObj(practiceName: practice.practice!)
        NotesArray = practiceNotes.getNotesByUid(uid: valueArray.noteuid!)
        self.title  = practiceName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Set properties of tableView Header
        tableViewHeader.layer.cornerRadius = tableViewHeader.frame.height / 5
        self.title = practiceName
    }
}

extension ActivityProgressVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityProgressCell
        let date = NotesArray![indexPath.row].noteDate! as Date
    
        cell.activityDateLabel.text = date.dateFormatemmmdd()
        cell.activityNotesTextView.text = NotesArray![indexPath.row].note
        if NotesArray![indexPath.row].practiceData?.practised == true {
            cell.practicedDaysLabel.text = "Yes"
        } else {
            cell.practicedDaysLabel.text = "No"
        }
        return cell
    }
    
}
