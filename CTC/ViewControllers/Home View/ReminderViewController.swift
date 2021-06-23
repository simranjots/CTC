import UIKit
import CoreData

class ReminderViewController: UIViewController {
    
    @IBOutlet weak var remindTableview: UITableView!
   
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let weekDict = ["Sunday" : 1, "Monday" : 2, "Tuesday" : 3, "Wednesday" : 4, "thursday" : 5, "Friday" : 6, "Saturday" : 7]
    var label = " "
    var hourlabel = " "
    var minutelabel = " "
    var practiceName = ""
    var value = ""
    var reminder = [Reminder]()
    var practiceReminder : PracticeReminder!
    var popUp : PopUpReminder!
    var userObject: User!
    var currentUser : CurrentUser!
    var userPractices: UserPractices!
    var practices:[Practice]!
    var addPrac : AddPracticesViewController!
    typealias completion = (Bool)->Void
    static var switchCompletion:completion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = CurrentUser()
        userPractices = UserPractices()
        userObject = currentUser.checkLoggedIn()
        practices = self.getPractices()
        practiceReminder = PracticeReminder()
        addPrac = AddPracticesViewController()
        popUp = PopUpReminder()
        reminder = practiceReminder.loadReminderbyPracticeName(practiceName: practiceName)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        reminder = practiceReminder.loadReminderbyPracticeName(practiceName: practiceName)
        if reminder.first?.identifier != nil {
                self.dismiss(animated: true)
                ReminderViewController.switchCompletion(true)
            }else{
                self.dismiss(animated: true)
                ReminderViewController.switchCompletion(false)
                
            }
      
           
        }
    
    
    @IBAction func addPressed(_ sender: Any) {
        if value == "edit" {
            PopUpReminder.value = "add"
            PopUpReminder.practiceName = practiceName
            PopUpReminder.searchCompletion = {(flag) in
             if(flag){
                self.reloadTable()
             }
            }
            popUp.showPopup(parentVC: self)
        }else{
            for practiceData in practices{
                
                if(practiceData.practice == practiceName){
                    
                   showToast(message: "Please Change the Practice Name it already exist", duration: 1)
                }else{
                    PopUpReminder.value = "add"
                    PopUpReminder.practiceName = practiceName
                    PopUpReminder.searchCompletion = {(flag) in
                     if(flag){
                        self.reloadTable()
                     }
                    }
                    popUp.showPopup(parentVC: self)
                }
            }
           
        }
        
    }
    
    func reloadTable(){
         practiceReminder = PracticeReminder()
         popUp = PopUpReminder()
        reminder = practiceReminder.loadReminderbyPracticeName(practiceName: practiceName)
        self.remindTableview.reloadData()
    }
    
    private func getPractices() -> [Practice]{
        
        
        return userPractices.getPractices(user: userObject)!
        
    }
   
}

extension ReminderViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return reminder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindCell") as! ReminderTableViewCell
        let date = NSDate()
        let calendar = NSCalendar.current
        let hours = calendar.component(.hour, from: date as Date)
        let remind = reminder[indexPath.row]
        if hours >= 12{
            cell.timeField.text = "\(remind.day!) " + " \(remind.hour):\(remind.minute) PM"
        }else{
            cell.timeField.text = "\(remind.day!) " + " \(remind.hour):\(remind.minute) AM"
        }
   
        return cell
    }
    
    
}
extension ReminderViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PopUpReminder.practiceName = practiceName
        PopUpReminder.myindex = indexPath.row
        PopUpReminder.value = "update"
        PopUpReminder.labels = reminder[indexPath.row].day!
        PopUpReminder.hourlabel = reminder[indexPath.row].hour
        PopUpReminder.minutelabel = reminder[indexPath.row].minute
        PopUpReminder.searchCompletion = {(flag) in
         if(flag){
            self.reloadTable()
         }
        }
        popUp.showPopup(parentVC: self)
        tableView.deselectRow(at: indexPath, animated: true)
      
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            let remind = self.reminder[indexPath.row]
                self.practiceReminder.deleteReminder(reminder: remind)
                self.reloadTable()
        }
       
    }
    
    
    
}

