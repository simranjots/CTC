import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    let ReminderPickerView = UIPickerView()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    var weekdays = ["Everyday", "Weekdays", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let hour: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10","11","12","13", "14", "15", "16", "17", "18", "19", "20", "21", "22","23","24"]
    
    let minute: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10","11","12","13", "14", "15", "16", "17", "18", "19", "20", "21", "22","23","24","25", "26", "27", "28", "29", "30", "31", "32", "33", "34","35","36","37", "38", "39", "40", "41", "42", "43", "44", "45", "46","47","48","49", "50", "51", "52", "53", "54", "55", "56", "57", "58","59","60"]
    var label = " "
    var hourlabel = " "
    var minutelabel = " "
    override func awakeFromNib() {
        super.awakeFromNib()
        ReminderPickerView.dataSource = self
        ReminderPickerView.delegate = self
        
        // Initialization code
        timeField.inputView = ReminderPickerView
        
        
        ReminderPickerView.delegate?.pickerView?(ReminderPickerView, didSelectRow: 0, inComponent: 0)
        ReminderPickerView.delegate?.pickerView?(ReminderPickerView, didSelectRow: 0, inComponent: 1)
        ReminderPickerView.delegate?.pickerView?(ReminderPickerView, didSelectRow: 0, inComponent: 2)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
    }
  
}
extension ReminderTableViewCell: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return weekdays.count
        }
        else if component == 1 {
            return hour.count
        }else if component == 2{
            return minute.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            
            return weekdays[row]
        }
        else if component == 1 {
            
            return hour[row]
            
        }else if component == 2{
            
            return minute[row]
        }
        return " "
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        label = weekdays[ReminderPickerView.selectedRow(inComponent: 0)]
        hourlabel = hour[ReminderPickerView.selectedRow(inComponent: 1)]
        minutelabel = minute[ReminderPickerView.selectedRow(inComponent: 2)]
        let value = Int(hourlabel)
        if value! >= 12{
            timeField.text = "\(label) " + " \(hourlabel):\(minutelabel) PM"
        }else{
            timeField.text = "\(label) " + " \(hourlabel):\(minutelabel) AM"
        }
        
        let reminder = Reminder(context: self.context)
        
        if component == 0 {
            print(String(weekdays[row]))
        }
        else if component == 1 {
            print(String(hour[row]))
            reminder.hour = Int16(hour[row])!
        }else{
            print(String(minute[row]))
            reminder.minute = Int16(minute[row])!
        }
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
    }
}
