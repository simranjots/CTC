import UIKit
import UserNotifications
import Firebase

class HomeViewController: UIViewController,ReceiveData{
    
    // variables
    var dbHelper : DatabaseHelper!
    var practiceHistory: PracticedHistory!
    var currentUser : CurrentUser!
    var userPractices: UserPractices!
    var userPracticesData: UserPracticesData!
    var selectedDate: Date!
    var indexpath : Int = 0
    var switchFlag  : Bool?
    var window: UIWindow!
    var userObject: User!
    var practices:[Practice]!
    var practicesData: [PracticeData]!
    var practiceReminder : PracticeReminder!
    var isOn : Bool?
    typealias completion = (Bool)->Void
    static var practiceAdded:completion!
    let db = FirebaseDataManager()
    // variables
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var dateTextField: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet var nameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        selectedDate = Date().dateFormate()!
        practices = self.getPractices(user: userObject)
        if UserDefaults.standard.bool(forKey: "weekly"){
        if practices != nil {
                for data in practices{
                    db.fetchMonthlyData(uid: data.uId!, docid: userObject.uid!) { [self] flag in
                        if flag {
                            refreshTableview(date: selectedDate)
                            UserDefaults.standard.set(false, forKey: "weekly")
                        }
                    }
                }
            
        }
    }
        refreshTableview(date: selectedDate)
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate = Date().dateFormate()!
        dateTextField.text = selectedDate.dateFormatemmmdd()
        dbHelper = DatabaseHelper()
        practiceHistory = PracticedHistory()
        currentUser = CurrentUser()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        userObject = currentUser.checkLoggedIn()
        nameLabel.text = greetingMessage(user: userObject)
        practiceReminder = PracticeReminder()
        practices = self.getPractices(user: userObject)
        _ = userPractices.oldestPracticeDate(user: userObject)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reloadHomeTableView), name:NSNotification.Name(rawValue: "NotificationID"), object: nil)
       
        
        // MARK: Gradiat Color Set for naviagation Bar
        if let navigationBar = self.navigationController?.navigationBar {
            let gradient = CAGradientLayer()
            var bounds = navigationBar.bounds
            bounds.size.height += UIApplication.shared.statusBarFrame.size.height
            gradient.frame = bounds
            gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
        }
        UserDefaults.standard.set(true, forKey: "DailyReminder")
        SetReminder()
        
         
        //MARK: for mainatain the practices data weekly
        //userPracticesData.maintainPracticeDataWeekly(user: userObject)
       
        
  }
    func SetReminder()  {
        if UserDefaults.standard.bool(forKey: "DailyReminder") {
            for i in 1...7 {
                NotificationManager.instance.scheduleNotification(hour: 7, minute: 0, weekday: i, identifier: "DailyReminder" + "\(i)", title:"Good Morning ,"+"\(userObject.name ?? "User")!" , body: "Practice Reminder: Stay on track to meet your goals. Let's get started!")
            }
        }
    }
    
    func greetingMessage(user: User) -> String {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        var message = ""
        
        switch hour {
        case 5...12 :
            message = "Good Morning, \(user.name!)!"
        case 13...16 :
            message = "Good Afternoon, \(user.name!)!"
        case 17...21 :
            message = "Good Evening, \(user.name!)!"
        case 21...24 :
            message = "Good Night, \(user.name!)!"
        case 0...5 :
            message = "Good Night, \(user.name!)!"
        default :
            print("Getting error in formating time.")
        }
        return message
    }
    
    
    
    @IBAction func ShowProgress(_ sender: UIBarButtonItem) {
        //ShowDetails
        performSegue(withIdentifier: "ShowDetails", sender: self)
    }
    
    private func getPractices(user: User) -> [Practice]{
        return userPractices.getPractices(user: user)!
    }
    
    
    
    @objc func reloadHomeTableView(){
        self.homeTableView.reloadData()
    }
    
    func passUserObject(user: User) {
        userObject = user
    }
    func onFriendSelected(index: Int) {indexpath = index }
   
    
    @IBAction func addPractices(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddPractices") as! AddPracticesViewController
        AddPracticesViewController.cvalue = "add"
        self.present(vc, animated: true, completion: nil)
        HomeViewController.practiceAdded  = {(flag) in
            if(flag){
                self.refreshTableview(date: self.selectedDate)
                
            }
        }
    }
    
    
    // Table View Code
    func delPractice(prac: Practice,userOb: User){
        let pracData = userPracticesData.getPracticeDataObj(practiceUid: prac.uId!)
        let pracName = prac.practice
        let td = pracData?.tracking_days
        let dss = (Date().dateFormate()!).days(from: (prac.startedday! as Date).dateFormate()!) + 1
        let flag = false
        let date = Date().dateFormate()!
        let uid = prac.uId

        userPractices.deletePractice(practice: prac)
    
        let resultFlag = practiceHistory.addPracticeHistory(hid: uid!, practiceName: pracName!, comDelFlag: flag, date: date, dss: dss, td: Int(td ?? 0),userOb:userOb)
        
        if(resultFlag == 0){
            showToast(message: "\(pracName!) Deleted", duration: 3, height: 30)
        } else {
            showToast(message: "Deletion Error", duration: 3, height: 30)
        }
        self.refreshTableview(date: selectedDate)
    }
    
    func refreshTableview(date: Date) {
        dbHelper = DatabaseHelper()
        practiceHistory = PracticedHistory()
        currentUser = CurrentUser()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        userObject = currentUser.checkLoggedIn()
        selectedDate = Date().dateFormate()!
        practices = userPractices.getPractices(user: userObject)
        nameLabel.text = greetingMessage(user: userObject)
        homeTableView.reloadData()
    }
    
    func isSwitchOn(practice: Practice, practicesData: [PracticeData]?) -> Bool? {
        var starButton : Bool = false
        if(practicesData != nil){
            for data in practicesData!{
                if data.pUid == practice.uId{
                    starButton = data.practised
                }
            }
            return starButton
        }
        return nil
    }
}


extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return practices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResolutionCell") as! HomeVCCell
        cell.activityNameLabel.text = practices[indexPath.row].practice
        cell.activityImageView.image = UIImage(named:practices[indexPath.row ].image_name!)
        cell.valueLabel.text = practices[indexPath.row].values
        cell.tagLineLabel.text = practices[indexPath.row].encourage
        practicesData = userPracticesData.getPracticeDataByDate(date: selectedDate)
        
        switchFlag = self.isSwitchOn(practice: practices[indexPath.row], practicesData: practicesData)
    
        
        if (switchFlag != nil){
            cell.isOn = switchFlag!
            cell.userObject = userObject
            cell.activeButton(flag: switchFlag!)
        } else {
            cell.userObject = userObject
            cell.activeButton(flag: false)
        }
        cell.practice = practices[indexPath.row]
        cell.selectedDate = selectedDate
        return cell
    }
}

extension HomeViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            
            let prac = self.practices[indexPath.row]
            
            let alert = UIAlertController(title: "Warning", message: "Do you want to delete \(prac.practice!)?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action:UIAlertAction) -> Void in
                self.practiceReminder.RemoveReminder(uid: prac.practice!)
                if let remind =  self.practiceReminder.loadReminderbyPracticeNameonly(uid: prac.uId!) {
                    self.practiceReminder.RemoveReminder(uid:prac.uId!)
                    self.practiceReminder.deleteReminder(reminder: remind)
                           }
                self.db.updateSinglePractices(collectionName: "Practices", valueName: "is_deleted", value: true, document: prac.uId!, uid: self.userObject.uid!)
                self.db.updateSinglePractices(collectionName: "PracticedData", valueName: "is_deleted", value: true, document: prac.uId!, uid: self.userObject.uid!)
                
                if (self.userPracticesData.getPracticeDataObj(practiceUid: prac.uId!) != nil) {
                    let p = self.userPracticesData.getPracticeDataObj(practiceUid: prac.uId!)
                    self.userPracticesData.deletePracticeData(practicesData: p!)
                    self.delPractice(prac: prac, userOb: self.userObject)
                }else{
                    self.delPractice(prac: prac, userOb: self.userObject)
                }
               
                   
                    
                
               
               
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddPractices") as! AddPracticesViewController
            AddPracticesViewController.cvalue = "edit"
            AddPracticesViewController.cindexPath = indexPath.row
            HomeViewController.practiceAdded  = {(flag) in
                if(flag){
                    self.refreshTableview(date: self.selectedDate)
                    
                }
            }
            self.present(vc, animated: true, completion: nil)
            
        }
        editAction.backgroundColor = .lightGray
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onFriendSelected(index: indexPath.row)
        HomeViewController.practiceAdded  = {(flag) in
            if(flag){
                self.refreshTableview(date: self.selectedDate)
                
            }
        }
        performSegue(withIdentifier: "HomeToAddDataSague", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! ActivityDetailsViewController
        destination.userObject = userObject
        destination.selectedPractice = practices[indexpath]
        destination.selectedDate = selectedDate
        destination.delegate = self
        
    }
}
