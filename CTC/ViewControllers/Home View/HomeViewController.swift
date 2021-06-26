import UIKit
import UserNotifications

class HomeViewController: UIViewController,ReceiveData{
    
    // variables
    var dbHelper: DatabaseHelper!
    var currentUser : CurrentUser!
    var userPractices: UserPractices!
    var userPracticesData: UserPracticesData!
    var selectedDate: Date!
    var datePicker : UIDatePicker!
    var myIndex: Int!
    var window: UIWindow!
    var practi:[Practice]!
    var userObject: User!
    var practices:[Practice]!
    var practicesData: [PracticeData]!
    var practiceReminder : PracticeReminder!
    typealias completion = (Bool)->Void
    static var practiceAdded:completion!
    // variables
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var dateTextField: UILabel!
    @IBOutlet weak var dateView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshTableview(date: selectedDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate = Date().dateFormate()!
        dateTextField.text = "Date : \(Date().dateFormatemmmdd()!)"
        dbHelper = DatabaseHelper()
        currentUser = CurrentUser()
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        userObject = currentUser.checkLoggedIn()
        practiceReminder = PracticeReminder()
        practices = self.getPractices()
        practicesData = self.getPracticesData(date: selectedDate)
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
        
        //MARK: for mainatain the practices data weekly
        userPracticesData.maintainPracticeDataWeekly(user: userObject)
        styleDateLabelView()
    }
    
    func styleDateLabelView() {
        
        //        dateView.layer.cornerRadius = dateView.frame.height / 6
        //        dateView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        //        dateView.layer.borderWidth = 1
    }
    
    @IBAction func ShowProgress(_ sender: UIBarButtonItem) {
        //ShowDetails
        performSegue(withIdentifier: "ShowDetails", sender: self)
    }
    
    private func getPractices() -> [Practice]{
        return userPractices.getPractices(user: userObject)!
    }
    
    private func getPracticesData(date: Date) -> [PracticeData]? {
        return dbHelper.getPracticeDataByDate(date: date.dateFormate()!)
    }
    
    @objc func reloadHomeTableView(){
        self.homeTableView.reloadData()
    }
    
    func passUserObject(user: User) {
        userObject = user
    }
    
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
    func delPractice(prac: Practice){
        
        let pracName = prac.practice
        let td = prac.practiseddays
        let dss = (Date().dateFormate()!).days(from: (prac.startedday! as Date).dateFormate()!) + 1
        let flag = false
        let date = Date().dateFormate()!
        
        userPractices.deletePractice(practice: prac)
        let resultFlag = dbHelper.addPracticeHistory(practiceName: pracName!, comDelFlag: flag, date: date, dss: dss, td: Int(td))
        
        if(resultFlag == 0){
            showToast(message: "\(pracName!) Deleted", duration: 3)
        } else {
            showToast(message: "Deletion Error", duration: 3)
        }
        self.refreshTableview(date: selectedDate)
    }
    
    func refreshTableview(date: Date) {
        userPractices = UserPractices()
        userPracticesData = UserPracticesData()
        currentUser = CurrentUser()
        userObject = currentUser.checkLoggedIn()
        selectedDate = Date().dateFormate()!
        practices = userPractices.getPractices(user: userObject)
        practicesData = self.getPracticesData(date: selectedDate)
        let oldestDate = userPractices.oldestPracticeDate(user: userObject)
        self.datePicker = UIDatePicker()
        self.datePicker.minimumDate = oldestDate
        homeTableView.reloadData()
    }
    
    func isSwitchOn(practice: Practice, practicesData: [PracticeData]?) -> Bool? {
        if(practicesData != nil){
            for data in practicesData!{
                if data.practiceDataToPractice == practice{
                    return data.practised
                }
            }
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
        
        let switchFlag = self.isSwitchOn(practice: practices[indexPath.row], practicesData: practicesData)
        
        if (switchFlag != nil){
            cell.isOn = switchFlag!
            cell.userObject = userObject
            cell.activeButton(flag: switchFlag!)
        } else {
            cell.userObject = userObject
            cell.activeButton(flag: false)
        }
        cell.practice = practices[indexPath.row]
        cell.selectedDate = datePicker.date.dateFormate()!
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
                self.practiceReminder.RemoveReminder(practiceName: prac.practice!)
                self.delPractice(prac: prac)
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
            self.present(vc, animated: true, completion: nil)
            
        }
        editAction.backgroundColor = .lightGray
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "HomeToAddDataSague", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! ActivityDetailsViewController
        destination.userObject = userObject
        destination.myIndex = myIndex
        destination.selectedDate = datePicker.date.dateFormate()!
        destination.delegate = self
        
    }
}
