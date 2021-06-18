import UIKit
import CoreData

class ReminderViewController: UIViewController {

    @IBOutlet weak var remindTableview: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var reminder = [Reminder]()
   var increaseCell = 1
    var RemindDaysLabel = "Everyday"
    let toolBar = UIToolbar()
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
        
            //Toolbar
           
            toolBar.sizeToFit()
            //Toobar button
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
            toolBar.setItems([doneButton], animated: true)
    }
    @IBAction func donePressed(_ sender: UIButton) {
        let request : NSFetchRequest<Reminder> = Reminder.fetchRequest()
        do {
            reminder = try context.fetch(request)
            
        } catch let err {
            print(err)
        }
        print("\(Int(reminder[0].hour)) " + " \(Int(reminder[0].minute))  ")
    
        NotificationManager.instance.scheduleNotification(hour: Int(reminder[0].hour), minute: Int(reminder[0].minute), weekday: 5)
        self.dismiss(animated: true)
    }
   
   

    @IBAction func addPressed(_ sender: UIButton) {
        increaseCell += 1
        remindTableview.reloadData()
    }
    

}
extension ReminderViewController:UITableViewDelegate{
    
}
extension ReminderViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return increaseCell
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindCell") as! ReminderTableViewCell
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        cell.timeField.inputAccessoryView = toolBar
        if hour >= 12{
            cell.timeField.text = "\(RemindDaysLabel) " + " \(hour):\(minutes) PM"
        }else{
            cell.timeField.text = "\(RemindDaysLabel) " + " \(hour):\(minutes) AM"
        }
        
        return cell
    }
    
    
}

